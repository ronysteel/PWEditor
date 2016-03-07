//
//  CommonConst.swift
//  PWEditor
//
//  Created by 二俣征嗣 on 2016/02/19.
//  Copyright © 2016年 Masatsugu Futamata. All rights reserved.
//

import Foundation

struct CommonConst {

    struct ConfigKey {
        static let kAdmobAdUnitId = "admobAdUnitId"
        static let kAdmobTestDeviceId = "admobTestDeviceId"
        static let kDropBoxAppKey = "dropboxAppKey"
        static let kDropBoxAppSecret = "dropboxAppSecret"
    }

    struct SlidingViewSetting {
        static let kShadowOpacity: Float = 0.75
        static let kShadowRadius: CGFloat = 5.0
        static let kRightRevealAmount: CGFloat = 250.0
    }

    /**
     フォントファミリー名情報
     */
    struct FontFamilyName {
        static let KCourierNew = "CourierNew"
        static let kArial = "Arial"
        static let kSourceHanCodeJp = "SourceHanCodeJP"
    }
    /**
     フォントファミリー名インデックス
     */
    struct FontFamilyNameIndex {
        static let kCourierNew = 0
        static let kArial = 1
        static let kSourceHanCodeJp = 2
    }
    /// フォントファミリー名リスト
    static let FontFamilyNameList = [FontFamilyName.KCourierNew, FontFamilyName.kArial, FontFamilyName.kSourceHanCodeJp]

    /**
     フォント名情報
     */
    struct FontName {
        /// CourierNew
        static let kCourierNew = "CourierNewPSMT"

        /// Arial
        static let kArial = "ArialMT"

        /// Source Han Code JP(Normal)
        static let kSourceHanCodeJpNormal = "SourceHanCodeJP-Normal"
    }
    struct FontNameIndex {
        static let kCourierNew = 0
        static let kArial = 1
        static let kSourceHanCodeJpNormal = 2
    }
    static let FontNameList = [FontName.kCourierNew, FontName.kArial, FontName.kSourceHanCodeJpNormal]

    /**
     フォントサイズ
     */
    struct FontSize {
        /// デフォルト
        static let kDefault: CGFloat = UIFont.systemFontSize()

        /// 入力用
        static let kEnterData: CGFloat = 12.0
    }

    enum CharCodeType: Int {
        case Utf8 = 0
        case ShiftJis = 1
        case Euc = 2
    }

    static let CharCodeNameList = [
        "UTF-8",
        "Shift_JIS",
        "EUC"
    ]

    static let CharCodeList = [
        NSUTF8StringEncoding,
        NSShiftJISStringEncoding,
        NSJapaneseEUCStringEncoding
    ]

    enum RetCodeType: Int {
        case LF = 0
        case CRLF = 1
        case CR = 2
    }

    static let RetCodeNameList = [
        "UNIX(LF)",
        "Windows(CR/LF)",
        "Mac(CR)"
    ]
}