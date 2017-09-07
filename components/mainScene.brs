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
sub init()
    m.dateLabel = m.top.findNode("dateLabel")
    m.datePicker = m.top.findNode("datePicker")
    m.monthList = m.top.findNode("monthList")
    m.monthList.focusBitmapUri = "pkg:/images/date-back.png"
    m.monthList.focusFootprintBitmapUri = "pkg:/images/date-back.png"
    m.monthList.observeField("itemFocused", "onDateItemFocused")
    m.monthList.observeField("itemSelected", "onDateItemSelected")
    m.dayList = m.top.findNode("dayList")
    m.dayList.focusBitmapUri = "pkg:/images/date-back.png"
    m.dayList.focusFootprintBitmapUri = "pkg:/images/date-back.png"
    m.dayList.observeField("itemFocused", "onDateItemFocused")
    m.dayList.observeField("itemSelected", "onDateItemSelected")
    m.yearList = m.top.findNode("yearList")
    m.yearList.focusBitmapUri = "pkg:/images/date-back.png"
    m.yearList.focusFootprintBitmapUri = "pkg:/images/date-back.png"
    m.yearList.observeField("itemFocused", "onDateItemFocused")
    m.yearList.observeField("itemSelected", "onDateItemSelected")
    m.dateButtons = m.top.findNode("dateButtons")
    m.dateButtons.focusBitmapUri = "pkg:/images/button-back-focus.png"
    m.dateButtons.focusFootprintBitmapUri = "pkg:/images/button-back-footprint.png"
    m.dateButtons.observeField("buttonSelected", "onButtonSelected")
    m.dateButtons.buttons = [tr("OK"), tr("Cancel")]
    m.Overhang = m.top.findNode("Overhang")
    deviceInfo = createObject("roDeviceInfo")
    m.locale = deviceInfo.GetCurrentLocale()
    m.top.findNode("lblTitle").text = tr("Select a Date")
    if m.locale <> "en_US"
        m.dayList.translation = [50,75]
        m.monthList.translation = [160,75]
    end if
    loadDateLists()
end sub

sub loadDateLists()
    date = CreateObject("roDateTime")
    currYear = date.GetYear()
    range = 5
    content = createObject("roSGNode", "ContentNode")
    for year = currYear - range to currYear + range
        item = createObject("roSGNode", "ContentNode")
        item.setFields({title: year.toStr()})
        content.appendChild(item)
    next
    m.yearList.content = content
    m.yearList.jumpToItem = range
    content = createObject("roSGNode", "ContentNode")
    months = tr("Months,Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec").split(",")
    for month = 1 to 12
        item = createObject("roSGNode", "ContentNode")
        item.setFields({title: months[month]})
        content.appendChild(item)
    next
    m.monthList.content = content
    m.monthList.jumpToItem = date.GetMonth() - 1
    content = createObject("roSGNode", "ContentNode")
    for day = 1 to 31
        item = createObject("roSGNode", "ContentNode")
        item.setFields({title: day.toStr()})
        content.appendChild(item)
    next
    m.dayList.content = content
    m.dayList.jumpToItem = date.GetDayOfMonth() - 1
    'focus all lists to initialize "itemFocused" property
    m.yearList.setFocus(true)
    if m.locale = "en_US"
        m.dayList.setFocus(true)
        m.monthList.setFocus(true)
    else
        m.monthList.setFocus(true)
        m.dayList.setFocus(true)
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    focus = ""
    result = false
    if press
        if key = "left"
            if m.locale = "en_US"
                if m.yearList.hasFocus()
                    focus = "dayList"
                else if m.dayList.hasFocus()
                    focus = "monthList"
                else if not m.monthList.hasFocus()
                    focus = "yearList"
                end if
            else
                if m.yearList.hasFocus()
                    focus = "monthList"
                else if m.monthList.hasFocus()
                    focus = "dayList"
                else if not m.dayList.hasFocus()
                    focus = "yearList"
                end if
            end if
        else if key = "right"
            if m.yearList.hasFocus()
                focus = "dateButtons"
            else if m.locale = "en_US"
                if m.monthList.hasFocus()
                    focus = "dayList"
                else if m.dayList.hasFocus()
                    focus = "yearList"
                end if
            else
                if m.dayList.hasFocus()
                    focus = "monthList"
                else if m.monthList.hasFocus()
                    focus = "yearList"
                end if
            end if
        end if
        if focus <> ""
            m.top.findNode(focus).setFocus(true)
            result = true
        end if
    end if
    return result
end function

sub onDateItemFocused(eventObj as object)
    name = eventObj.getNode()
    index = eventObj.getData()
    'update day list based on month and year
    if name = "monthList" or name = "yearList"
        m.year = m.yearList.content.getChild(m.yearList.itemFocused).title
        m.month = zeroPad((m.monthList.itemFocused + 1).ToStr())
        date = convertDate(m.year, m.month, "01")
        selDay = m.dayList.itemFocused
        lastDay = date.GetLastDayOfMonth()
        childs = m.dayList.content.getChildCount()
        if lastDay < childs
            res = m.dayList.content.removeChildrenIndex(childs - lastDay, lastDay)
            if selDay >= lastDay
                m.dayList.jumpToItem = lastDay - 1
                m.day = zeroPad(lastDay.ToStr())
            end if
        else if lastDay > childs
            for day = childs + 1 to lastDay
                item = createObject("roSGNode", "ContentNode")
                item.setFields({title: day.toStr()})
                res = m.dayList.content.appendChild(item)
            next
        end if
    else if name = "dayList"
        m.day = zeroPad((index+1).ToStr())
    end if
end sub

sub onDateItemSelected(eventObj as object)
    print "cardScreen.brs - onDateItemSelected"
    name = eventObj.getNode()
    if name = "yearList"
        m.dateButtons.setFocus(true)
    else if m.locale = "en_US"
        if name = "monthList"
            m.dayList.setFocus(true)
        else if name = "dayList"
            m.yearList.setFocus(true)
        end if
    else
        if name = "dayList"
            m.monthList.setFocus(true)
        else if name = "monthList"
            m.yearList.setFocus(true)
        end if
    end if
end sub

sub onButtonSelected(eventObj as object)
    selectedDate = tr("No Date Selected")
    if eventObj.getData() = 0  'Save
        date = convertDate(m.year, m.month, m.day)
        if date <> invalid
            selectedDate = date.AsDateString("long-date")
        end if
    end if
    m.datePicker.visible = false
    m.dateLabel.text = selectedDate
    m.dateLabel.visible = true
end sub

function convertDate(year, month, day) as object
    date = CreateObject("roDateTime")
    date.FromISO8601String(year + "-" + month + "-" + day + "T12:00:00Z")
    return date
end function

function zeroPad(text as string, length = invalid) As String
    if length = invalid then length = 2
    if text.Len() < length
        for i = 1 to length-text.Len()
            text = "0" + text
        next
    end If
    return text
end function
