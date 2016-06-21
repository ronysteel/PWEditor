//
//  ExportDropboxViewController.swift
//  PWEditor
//
//  Created by mfuta1971 on 2016/06/20.
//  Copyright © 2016年 Masatsugu Futamata. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SwiftyDropbox

/**
 Dropboxファイルエクスポート画面
 
 - Version: 1.0 新規作成
 - Author: paveway.info@gmail.com
 */
class ExportDropboxFileViewController: BaseTableViewController, UIGestureRecognizerDelegate {

    // MARK: - Constants

    /// 画面タイトル
    let kScreenTitle = LocalizableUtils.getString(LocalizableConst.kExportDropboxFileScreenTitle)

    // MARK: - Variables

    /// テーブルビュー
    @IBOutlet weak var tableView: UITableView!

    /// バナービュー
    @IBOutlet weak var bannerView: GADBannerView!

    /// 遷移元クラス名
    private var sourceClassName: String!

    /// パス名
    private var pathName: String!

    /// ファイル名
    private var fileName: String!

    /// ファイルデータ
    private var fileData: NSData!

    /// ディレクトリ情報リスト
    private var dirInfoList = [DropboxFileInfo]()

    // MARK: - Initializer

    /**
     イニシャライザ

     - Parameter coder: デコーダー
     */
    required init?(coder aDecoder: NSCoder) {
        // スーパークラスのメソッドを呼び出す。
        super.init(coder: aDecoder)
    }

    /**
     イニシャライザ

     - Parameter sourceClassName: 遷移元クラス名
     - Parameter pathName: パス名
     - Parameter fileName: ファイル名
     - Parameter fileData: ファイルデータ
     */
    init(sourceClassName: String, pathName: String, fileName: String, fileData: NSData) {
        // 引数のデータを保存する。
        self.sourceClassName = sourceClassName
        self.pathName = pathName
        self.fileName = fileName
        self.fileData = fileData

        // スーパークラスのメソッドを呼び出す。
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - UIViewController

    /**
     インスタンスが生成された時に呼び出される。
     */
    override func viewDidLoad() {
        // スーパークラスのメソッドを呼び出す。
        super.viewDidLoad()

        // 画面タイトルを設定する。
        navigationItem.title = kScreenTitle

        // 右バーボタンを作成する。
        createRightBarButton()

        // テーブルビューを設定する。
        setupTableView(tableView)

        // セルロングタップを設定する。
        createCellLogPressed(tableView, delegate: self)

        // バナービューを設定する。
        setupBannerView(bannerView)

        if pathName == "/" {
            // ルートディレクトリの場合
            let dirInfo = DropboxFileInfo()
            dirInfo.name = pathName
            dirInfo.isDir = true
            dirInfoList.append(dirInfo)

        } else {
            // ルートディレクトリ以外の場合
            getDirInfoList(pathName)
        }
    }

    /**
     メモリ不足の時に呼び出される。
     */
    override func didReceiveMemoryWarning() {
        LogUtils.w("memory error.")

        // スーパークラスのメソッドを呼び出す。
        super.didReceiveMemoryWarning()
    }

    // MARK: - UITableViewDataSource

    /**
     セクション内のセル数を返却する。

     - Parameter tableView: テーブルビュー
     - Parameter section: セクション番号
     - Returns: セクション内のセル数
     */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // ディレクトリ情報リストの件数を返却する。
        let count = dirInfoList.count
        return count
    }

    /**
     セルを返却する。

     - Parameter tableView: テーブルビュー
     - Parameter indexPath: インデックスパス
     - Returns: セル
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // セルを取得する。
        let cell = getTableViewCell(tableView)

        let row = indexPath.row
        let dirInfo = dirInfoList[row]
        let name = dirInfo.name
        cell.textLabel!.text = name
        cell.accessoryType = .DisclosureIndicator

        return cell
    }

    // MARK: - UITableViewDelegate

    /**
     セルが選択された時に呼び出される。

     - Parameter tableView: テーブルビュー
     - Parameter indexPath: インデックスパス
     */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // セルの選択状態を解除する。
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        // 次のサブディレクトリパス名を取得する。
        let row = indexPath.row
        let dirInfo = dirInfoList[row]
        let name = dirInfo.name
        let path: String
        if pathName == "/" {
            // ルートディレクトリの場合
            path = ""

        } else {
            if pathName == "" {
                // 1階層目の場合
                path = "/\(name)"

            } else {
                // 2階層目以降の場合
                path = "\(pathName)/\(name)"
            }
        }

        // Dropboxファイルエクスポート画面に遷移する。
        let vc = ExportDropboxFileViewController(sourceClassName: sourceClassName, pathName: path, fileName: fileName, fileData: fileData)
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Button handler

    /**
     セルがロングタップされた時に呼び出される。

     - Parameter recognizer: セルロングタップジェスチャーオブジェクト
     */
    override func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        // インデックスパスを取得する。
        let point = recognizer.locationInView(tableView)
        let indexPath = tableView!.indexPathForRowAtPoint(point)

        if indexPath == nil {
            // インデックスパスが取得できない場合、処理を終了する。
            return
        }

        if recognizer.state == UIGestureRecognizerState.Began {
            // ジェスチャーが開始状態の場合
            // チェックマークを設定する。
            let cell = tableView.cellForRowAtIndexPath(indexPath!)
            if cell == nil {
                return
            }

            if cell!.accessoryType == .Checkmark {
                // チェックマークが設定されている場合
                cell!.accessoryType = .DisclosureIndicator

            } else {
                // チェックマークが設定されていない場合
                cell!.accessoryType = .Checkmark
            }

            // 選択されていないセルのチェックマークを外す。
            let count = dirInfoList.count
            let row = indexPath!.row
            for i in 0 ..< count {
                if i != row {
                    let unselectedIndexPath = NSIndexPath(forRow: i, inSection: 0)
                    let unselectedCell = tableView.cellForRowAtIndexPath(unselectedIndexPath)
                    unselectedCell?.accessoryType = .DisclosureIndicator
                }
            }
        }
    }

    // MARK: - Bar button

    /**
     右バーボタン押下時に呼び出される。

     - Parameter sender: 右バーボタン
     */
    override func rightBarButtonPressed(sender: UIButton) {
        // 選択されたディレクトリ情報を取得する。
        var dirInfo: DropboxFileInfo? = nil
        let rowNum = tableView?.numberOfRowsInSection(0)
        for var i = 0; i < rowNum; i += 1 {
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            let cell = tableView?.cellForRowAtIndexPath(indexPath)
            let check = cell?.accessoryType

            if check == UITableViewCellAccessoryType.Checkmark {
                let row = indexPath.row
                dirInfo = dirInfoList[row]
                break
            }
        }

        if dirInfo == nil {
            // 選択されたディレクトリ情報が取得できない場合
            // エラーアラートを表示して終了する。
            let title = LocalizableUtils.getString(LocalizableConst.kAlertTitleError)
            let message = LocalizableUtils.getString(LocalizableConst.kAlertMessageDirNotSelectError)
            showAlert(title, message: message)
            return
        }

        // エクスポート先パス名を取得する。
        let dirName = dirInfo!.name
        let filePathName: String
        if pathName == "/" {
            // ルートディレクトリの場合
            filePathName = "/\(fileName)"

        } else {
            // ルートディレクトリ以外の場合
            if pathName.isEmpty {
                // 1階層目の場合
                filePathName = "/\(dirName)/\(fileName)"

            } else {
                // 2階層目以降の場合
                filePathName = "\(pathName)/\(dirName)/\(fileName)"
            }
        }

        // ファイルをエクスポートする。
        exportFile(filePathName)
    }

    // MARK: - Dropbox

    /**
     ファイル情報リストを取得する。

     - Parameter pathName: パス名
     - Parameter index: ファイル情報の位置
     */
    func getDirInfoList(pathName: String) {
        // リフレッシュコントロールを停止する。
        refreshControl?.endRefreshing()

        let client = Dropbox.authorizedClient
        if client == nil {
            // Dropboxが無効な場合
            return
        }

        // ネットワークアクセス通知を表示する。
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        // ディレクトリ内のファイル一覧を取得する。
        client!.files.listFolder(path: pathName).response { response, error in
            // ネットワークアクセス通知を消す。
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false

            if error != nil || response == nil {
                // エラーの場合
                // エラーアラートを表示する。
                let title = LocalizableUtils.getString(LocalizableConst.kAlertTitleError)
                let message = LocalizableUtils.getString(LocalizableConst.kDropboxFileListGetFileInfoListError)
                self.showAlert(title, message: message, handler: nil)
                return
            }

            self.dirInfoList.removeAll(keepCapacity: false)
            let result = response
            for entry in result!.entries {
                if entry.dynamicType == Files.FolderMetadata.self {
                    // ディレクトリの場合
                    let fileInfo = DropboxFileInfo()
                    let name = entry.name
                    fileInfo.name = name
                    fileInfo.isDir = true
                    self.dirInfoList.append(fileInfo)
                }
            }

            let count = self.dirInfoList.count
            if count > 0 {
                // サブディレクトリがある場合
                // テーブルビューを更新する。
                self.tableView.reloadData()

            } else {
                // サブディレクトリが無い場合
                // エラーアラートを表示する。
                let title = LocalizableUtils.getString(LocalizableConst.kAlertTitleError)
                let message = LocalizableUtils.getString(LocalizableConst.kAlertMessageNoDirectoryError)
                let okButtonTitle = LocalizableUtils.getString(LocalizableConst.kButtonTitleClose)
                self.showAlert(title, message: message, okButtonTitle: okButtonTitle) {
                    // 遷移元画面に戻る。
                    self.popViewController()
                }
            }
        }
    }

    /**
     エクスポートを行う。

     - Parameter filePathName: ファイルパス名
     */
    private func exportFile(filePathName: String) {
        let client = Dropbox.authorizedClient
        if client == nil {
            // Dropboxが無効な場合
            // エラーアラートを表示する。
            let title = LocalizableUtils.getString(LocalizableConst.kAlertTitleError)
            let message = LocalizableUtils.getString(LocalizableConst.kAlertMessageDropboxInvalid)
            self.showAlert(title, message: message)
            return
        }

        // ネットワークアクセス通知を表示する。
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        client!.files.upload(path: filePathName, body: fileData).response { response, error in
            // ネットワークアクセス通知を消す。
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false

            if error != nil || response == nil {
                // エラーの場合
                let title = LocalizableUtils.getString(LocalizableConst.kAlertTitleError)
                let message = LocalizableUtils.getStringWithArgs(LocalizableConst.kCreateDropboxFileCreateError, self.fileName)
                self.showAlert(title, message: message, handler: { () -> Void in
                    // 遷移元画面に戻る。
                    self.popViewController()
                })
                return
            }

            // 遷移元画面に戻る。
            self.popViewController()
        }
    }

    /**
     遷移元画面に戻る。
     */
    func popViewController() {
        // 画面遷移数を取得する。
        let count = navigationController?.viewControllers.count
        // 最後に表示した画面から画面遷移数確認する。
        for var i = count! - 1; i >= 0; i-- {
            let vc = navigationController?.viewControllers[i]
            if vc!.dynamicType.description() == sourceClassName {
                // 表示した画面が遷移元画面の場合
                // 画面を戻す。
                navigationController?.popToViewController(vc!, animated: true)
                break
            }
        }
    }
}
