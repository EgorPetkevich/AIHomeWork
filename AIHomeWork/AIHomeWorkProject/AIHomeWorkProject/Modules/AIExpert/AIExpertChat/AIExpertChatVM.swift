//
//  AIExpertChatVM.swift
//  AIHomeWorkProject
//
//  Created by George Popkich on 12.09.24.
//

import UIKit
import Storage
import Photos

protocol AIExpertChatCoordinatorProtocol: AnyObject {
    func showMenu(sender: UIView, delegate: ResultsMenuDelegate)
    func showImagePicker(picker: UIImagePickerController)
    func openCamera(comletion: ((UIImage) -> Void)?)
    func openChat()
}

protocol AIExpertChatAdapterProtocol {
    func makeTableView() -> UITableView
    func reloadData(whith chat: [ChatDTO])
    func reloadData()
    func scrollToBottom()
}

protocol AIExpertChatOpenAIServiceUseCaseProtocol {
    typealias TaskCompletionHandler = ((ChatDTO?) -> Void)?
    func fetchChat(dto: any DTODescription,
                   completion: TaskCompletionHandler)
}

protocol AIExpertChatAlertServiceUseCaseProtocol {
    typealias AlertActionHandler = () -> Void
    typealias ActionHandler = (_ text: String?) -> Void
    func showRenameChatInput(actionHandler: ActionHandler?)
    func showActionSheet(takeFotoHandler: AlertActionHandler?,
                          openGalleryHandler: AlertActionHandler?)
    func showCameraError(goSettingsHandler: AlertActionHandler?)
}

protocol AIExpertChatConvStorageUseCaseProtocol {
    typealias CompletionHandler = (Bool) -> Void
    
    func create(dto: any DTODescription,
                completion: CompletionHandler?)
    func addChatAndUpdate(conversationDTO: ConversationDTO,
                          chatDTO: ChatDTO,
                          completion: ((ConversationDTO?) -> Void)?)
    func delete(dto: ConversationDTO,
                completion: CompletionHandler?)
    func renameConversation(conversationDTO: ConversationDTO,
                            newName: String,
                            completion: ((ConversationDTO?) -> Void)?)
}

protocol AIExpertChatKeyboardHelperUseCaseProtocol {
    @discardableResult
    func onWillShow(_ handler: @escaping (CGRect) -> Void) -> KeyboardHelper
    @discardableResult
    func onWillHide(_ handler: @escaping (CGRect) -> Void) -> KeyboardHelper
}

protocol AIExpertChatFileManagerServiceUseCaseProtocol {
    typealias CompletionHandler = (Bool) -> Void
    func saveImage(image: UIImage,
                   with path: String,
                   completion: CompletionHandler?)
    func delete(with path: String)
}

final class AIExpertChatVM: NSObject {
    
    static let hiMessage = "Hello!\nI’m your AI Tutor, ready to help! What’s your question?"
    
    var chats: [ChatDTO] = [] {
        didSet {
            adapter.reloadData(whith: chats)
        }
    }
    
    private var imageUrl: String?
    private var textFromImage: String?
    
    private let textRecognitionService = TextRecognitionService()
    
    var allowChatEditing: ((Bool) -> Void)?
    var imageDidSelect: ((UIImage) -> Void)?
    var allowSendind: ((Bool) -> Void)?
    var allowImagePicking: ((Bool) -> Void)?
    var keyboardOnWillShow: ((CGRect) -> Void)?
    var keyboardOnWillHide: (() -> Void)?
    var newConversationName: ((String) -> Void)?
    var saveImageCompleted: (() -> Void)?
    
    weak var coordinator: AIExpertChatCoordinatorProtocol?
    
    private var dto: (any DTODescription)?
    
    private let chatService: AIExpertChatOpenAIServiceUseCaseProtocol
    private let alertService: AIExpertChatAlertServiceUseCaseProtocol
    private let adapter: AIExpertChatAdapterProtocol
    private let keyboardHelper: AIExpertChatKeyboardHelperUseCase
    private let storage: AIExpertChatConvStorageUseCaseProtocol
    private let fileManager: AIExpertChatFileManagerServiceUseCaseProtocol
    
    init(coordinator: AIExpertChatCoordinatorProtocol,
         adapter: AIExpertChatAdapterProtocol,
         chatService: AIExpertChatOpenAIServiceUseCaseProtocol,
         alertService: AIExpertChatAlertServiceUseCaseProtocol,
         keyboardHelper: AIExpertChatKeyboardHelperUseCase,
         storage: AIExpertChatConvStorageUseCaseProtocol,
         fileManager: AIExpertChatFileManagerServiceUseCaseProtocol,
         dto: (any DTODescription)?) {
        self.coordinator = coordinator
        self.adapter = adapter
        self.chatService = chatService
        self.storage = storage
        self.keyboardHelper = keyboardHelper
        self.alertService = alertService
        self.fileManager = fileManager
        self.dto = dto
        super.init()
        bindKeyboardHelper()
        getChat()
    }
    
    private func getChat() {
        guard let dto else {
            createConversationDTO()
            return
        }
        switch dto {
        case is ConversationDTO:
            chats = dto.chat
            renameConversation(newName: dto.name)
        case is TaskDTO:
            createConversationDTO() { [weak self] in
                self?.sendRequest(userRequest: dto.chat.first?.message ?? "")
            }
        default:
            return
        }
        
    }
    
    private func createConversationDTO(_ createCompleted: (() -> Void)? = nil) {
        let chat = ChatDTO(id: UUID().uuidString,
                           date: .now,
                           message: "Hello!\nI’m your AI Tutor, ready to help! What’s your question?",
                           role: ChatRole.assistant.rawValue)
        let dto: ConversationDTO = ConversationDTO(id: UUID().uuidString,
                                                   date: .now,
                                                   name: "New chat",
                                                   chat: [chat])
        storage.create(dto: dto) { [weak self] completion in
            if completion {
                self?.dto = dto
                self?.chats = dto.chat
                createCompleted?()
            }
        }
        return
    }
    
    private func fetchAndReloadChat(dto: ConversationDTO) {
        chatService.fetchChat(dto: dto) { [weak self] chatDTO in
            guard let chatDTO else { return }
            self?.addChat(to: dto, chat: chatDTO) { dto in
                guard let updatedDTO = dto else { return }
                self?.dto = updatedDTO
                self?.showLoadingChat(false)
                self?.chats = updatedDTO.chat
                self?.allowSendind?(true)
                self?.allowImagePicking?(true)
                if let _ = self?.imageUrl, let _ = self?.textFromImage {
                    self?.allowChatEditing?(true)
                    self?.imageUrl = nil
                    self?.textFromImage = nil
                }
            }
        }
    }
    
    private func addChat(to dto: ConversationDTO,
                         chat: ChatDTO,
                         completion: ((ConversationDTO?) -> Void)?) {
        storage.addChatAndUpdate(conversationDTO: dto,
                                 chatDTO: chat,
                                 completion: completion)
    }
    
    private func sendRequest(userRequest: String) {
        let chat = ChatDTO(id: UUID().uuidString,
                           date: .now,
                           message: textFromImage ?? userRequest,
                           role: ChatRole.user.rawValue,
                           imageUrl: imageUrl)
        self.allowSendind?(false)
        chats.append(chat)
        guard let convDTO = dto as? ConversationDTO else { return }
        addChat(to: convDTO, chat: chat) {
            [weak self] updatedDTO in
            guard let updatedDTO else { return }
            self?.fetchAndReloadChat(dto: updatedDTO)
            self?.showLoadingChat(true)
        }
    }
    
    private func removeConversation() {
        guard let convDTO = dto as? ConversationDTO else { return }
        convDTO.chat.forEach { chat in
            guard let imageUrl = chat.imageUrl else { return }
            fileManager.delete(with: imageUrl)
        }
        storage.delete(dto: convDTO, completion: { [weak self] complition in
            if complition {  self?.coordinator?.openChat() }
        })
    }
    
    private func renameConversation(newName: String) {
        guard let convDTO = dto as? ConversationDTO else { return }
        storage.renameConversation(conversationDTO: convDTO,
                                   newName: newName) { [weak self] updatedDTO in
            guard let updatedDTO else { return }
            self?.dto = convDTO
            self?.newConversationName?(updatedDTO.name)
        }
    }
    
    private func showLoadingChat(_ sender: Bool) {
        if sender {
            let loadingChat = ChatDTO(id: UUID().uuidString,
                                      date: .now,
                                      message: "",
                                      role: "")
            chats.append(loadingChat)
        } else {
            chats.removeLast()
        }
    }
    
}

extension AIExpertChatVM: AIExpertChatViewModelProtocol {
    
    func sendButtonDidTap(userRequest: String) {
        sendRequest(userRequest: userRequest)
    }
    
    func openGalleryButtonDidTap() {
        alertService.showActionSheet { [weak self] in
            self?.coordinator?.openCamera(comletion: { image in
                self?.imageDidSelect?(image)
                self?.fileManagerSave(image: image)
                self?.allowImagePicking?(false)
                
            })
        } openGalleryHandler: { [weak self] in
            self?.allowChatEditing?(false)
            self?.openGallery()
        }

    }
    
    func loadImageAnimationCompleted() {
//        allowSendind?(true)
    }
    
    func loadingImageCanceled() {
        fileManagerdelete()
        
    }
    
    func viewDidLoad() {
        adapter.reloadData(whith: chats)
    }
    
    func makeTableView() -> UITableView {
        adapter.makeTableView()
    }
    
    func menuButtonDidTap(sender: UIView) {
        coordinator?.showMenu(sender: sender, delegate: self)
    }
    
    func backButtonDidTap() {
        coordinator?.openChat()
    }
    
}

extension AIExpertChatVM: ResultsMenuDelegate {
    
    func didSelect(action: ResultsMenuVC.Action) {
        switch action {
        case .rename:
            showRenameChatInput()
            return
        case .delete:
            removeConversation()
            return
        default: return
        }
    }

}

//MARK: - Alert Service UseCase
extension AIExpertChatVM {
    
    private func showRenameChatInput() {
        alertService.showRenameChatInput { [weak self] newTitle in
            guard let newTitle else { return }
            self?.renameConversation(newName: newTitle)
        }
    }
    
}

//MARK: - KeyboardHelper Bind
extension AIExpertChatVM {
    
    private func bindKeyboardHelper() {
        keyboardHelper.onWillShow { [weak self] keyboardFrame in
            self?.adapter.scrollToBottom()
            self?.keyboardOnWillShow?(keyboardFrame)
        }
        .onWillHide { [weak self] keyboardFrame in
            self?.keyboardOnWillHide?()
        }
        
    }
}

//MARK: - Text Recognition Use Case
extension AIExpertChatVM {
    
    private func getTextFromImage(image: UIImage) {
        textRecognitionService.recognizeText(image: image) { [weak self] text in
            self?.textFromImage = text
            self?.saveImageCompleted?()
        }
    }
    
}

//MARK: - File Manager Use Cases
extension AIExpertChatVM {
    
    private func fileManagerSave(image: UIImage) {
        let path: String =  UUID().uuidString
        self.imageUrl = path
        fileManager.saveImage(image: image, with: path) { [weak self] sender in
            if sender { self?.getTextFromImage(image: image) }
        }
    }
    
    private func fileManagerdelete() {
        guard let imageUrl else { return }
        fileManager.delete(with: imageUrl)
    }
    
}

//MARK: - Gallery Setup
extension AIExpertChatVM: UIImagePickerControllerDelegate,
                          UINavigationControllerDelegate,
                          UIAdaptivePresentationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true) { [weak self] in
            if let image = info[.originalImage] as? UIImage {
                self?.imageDidSelect?(image)
                self?.fileManagerSave(image: image)
                self?.allowSendind?(false)
                self?.allowImagePicking?(false)
            } else {
                self?.allowChatEditing?(true)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            self?.allowSendind?(true)
            self?.allowChatEditing?(true)
            self?.allowImagePicking?(true)
        }
        
    }
    
    private func openGallery() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.createAndShowImagePicker()
            case .denied, .restricted, .notDetermined:
                self.showGalleryErrorAlert()
            default:
                break
            }
        }
    }
    
    private func createAndShowImagePicker() {
        DispatchQueue.main.async { [weak self] in
            let imagePickerVC = UIImagePickerController()
            imagePickerVC.sourceType = .photoLibrary
            imagePickerVC.delegate = self
            imagePickerVC.presentationController?.delegate = self
            self?.coordinator?.showImagePicker(picker: imagePickerVC)
        }
        
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.allowSendind?(true)
        self.allowChatEditing?(true)
        self.allowImagePicking?(true)
    }
    
    private func showGalleryErrorAlert() {
        DispatchQueue.main.async { [weak self] in
            self?.alertService.showCameraError(goSettingsHandler: {
                if let appSettings =
                    URL(string: UIApplication.openSettingsURLString) {
                           UIApplication.shared.open(appSettings,
                                                     options: [:],
                                                     completionHandler: nil)
                    
                }
            })
            
        }
    }
    
}
