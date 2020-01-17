//
//  ViewController.swift
//  KKBOX
//
//  Created by Ninn on 2020/1/17.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit
import CRRefresh

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let provider = PlayListProvider()
    var playListModel: PlayListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset.top = -20
        
        getHitsPlayList()
        refreshData()
    }
    
    func getHitsPlayList() {
        provider.getHitsPlayList { result in
            switch result {
            case .success(let data):
                self.playListModel = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.cr.endHeaderRefresh()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func refreshData() {
        /// animator: 你的上拉刷新的Animator, 默认是 NormalHeaderAnimator
        tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            /// 开始刷新了
            /// 开始刷新的回调
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self?.getHitsPlayList()
                self?.tableView.cr.resetNoMore()
            })
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playListModel?.tracks.data.count ?? 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PlayListTableViewCell else {
            return UITableViewCell()
        }
        let playList = playListModel?.tracks.data[indexPath.row]
        cell.setData(data: playList)
        cell.delegate = self
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let mainImg = UIImageView()
        mainImg.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        mainImg.loadImage("https://i.kfs.io/playlist/global/26541395v266/cropresize/600x600.jpg")
        view.addSubview(mainImg)
        return view
    }
}

extension ViewController: FavoriteBtnStateDelegate {
    func getBtnState(_ cell: PlayListTableViewCell, _ btnState: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        playListModel?.tracks.data[indexPath.row].isLike = btnState
        tableView.reloadData()
    }
}
