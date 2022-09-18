import UIKit
import WebKit
import SwiftUI

class VimeoViewContriller: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let embedHTML:String! = "<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=yes\"/></head><body><div><iframe src=\"https://player.vimeo.com/video/653927419\" width=\"320\" height=\"180\" frameborder=\"0\" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div></body></html>"
//        let embedHTMLEncoding = embedHTML.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        let url = URL(string: "https://")
//        self.webView.loadHTMLString(embedHTML, baseURL: url)
        self.webView.loadHTMLString(embedHTML,baseURL: Bundle.main.bundleURL)
        self.webView.contentMode = UIView.ContentMode.scaleAspectFit
    }
}


/**
 SwiftUIでviewControllerを表示する際に必要なコード
 */
struct VimeoViewContrillerWrapper : UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> VimeoViewContriller {
        return VimeoViewContriller()
    }
    
    func updateUIViewController(_ uiViewController: VimeoViewContriller, context: Context) {
        
    }
}
