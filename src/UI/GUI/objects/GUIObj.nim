#Import the Wallet lib.
import ../../../Wallet/Wallet

#Events lib.
import ec_events

#Finals lib.
import finals

#WebView.
import ec_webview

#Constants of the HTML.
const
    MAIN*: string = staticRead("../static/Main.html")
    SEND*: string = staticRead("../static/Send.html")
    RECEIVE*: string = staticRead("../static/Receive.html")

#GUI object.
finalsd:
    type GUI* = ref object of RootObj
        toRPC* {.final.}: ptr Channel[string]
        toGUI* {.final.}: ptr Channel[string]
        webview* {.final.}: WebView

#Constructor.
proc newGUIObject*(
    toRPC: ptr Channel[string],
    toGUI: ptr Channel[string],
    webview: WebView
): GUI {.raises: [].} =
    GUI(
        toRPC: toRPC,
        toGUI: toGUI,
        webview: webview
    )