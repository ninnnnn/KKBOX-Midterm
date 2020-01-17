//
//  SongListTableViewCell.swift
//  KKBOX
//
//  Created by Ninn on 2020/1/17.
//  Copyright © 2020 Ninn. All rights reserved.
//

import UIKit

protocol FavoriteBtnStateDelegate: AnyObject {
    func getBtnState(_ cell: PlayListTableViewCell, _ btnState: Bool)
}
class PlayListTableViewCell: UITableViewCell {

    weak var delegate: FavoriteBtnStateDelegate?
    var btnState = false
    @IBOutlet weak var albumImg: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBAction func favoriteBtnClick(_ sender: Any) {
        if btnState {
            favoriteBtn.setImage(UIImage(named: "heart_fill"), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(named: "heart"), for: .normal)
        }
        btnState = !btnState
        delegate?.getBtnState(self, btnState)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setData(data: PlayList?) {
        albumImg.loadImage(data?.album.images[0].url)
        songLabel.text = data?.album.name
        let heartName = data?.isLike == true ? "heart_fill" : "heart"
        favoriteBtn.setImage(UIImage(named: heartName), for: .normal)
    }
}
