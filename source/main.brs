'*
'* Roku SceneGraph Date Picker example (BrightScript/RSG)
'* Copyright (c) 2017 Marcelo Lv Cabral (http://github.com/lvcabral)
'*
'* Permission is hereby granted, free of charge, to any person obtaining a
'* copy of this software and associated documentation files (the "Software"),
'* to deal in the Software without restriction, including without limitation
'* the rights to use, copy, modify, merge, publish, distribute, sublicense,
'* and/or sell copies of the Software, and to permit persons to whom the Software
'* is furnished to do so, subject to the following conditions:
'*
'* The above copyright notice and this permission notice shall be included in all
'* copies or substantial portions of the Software.
'*
'* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
'* INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
'* PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
'* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
'* OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
'* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
'*
sub main(input as dynamic)
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.SetMessagePort(m.port)
    scene = screen.CreateScene("MainScene")
    scene.backgroundUri = ""
    scene.backgroundColor = "#FFFFFFFF"
    screen.show()
    while true
        msg = wait(0, m.port)
        if type(msg) = "roSGScreenEvent"
            if msg.IsScreenClosed() then return
        end if
    end while
end Sub

