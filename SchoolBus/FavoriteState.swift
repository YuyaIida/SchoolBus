//
//  FavoriteState.swift
//  UISample
//
//  Created by k16005kk on 2018/08/09.
//  Copyright © 2018年 AIT. All rights reserved.
//

import Foundation

protocol AriticleState {
    func favoriteButtonTapped(articleCell: TimetableViewController)
}

class CellStateRegisteredAsFavorite: NSObject, AriticleState {
    func favoriteButtonTapped(articleCell: TimetableViewController) {
        articleCell.removeFavorite()
        articleCell.setState(state: CellStateNotRegisteredAsFavorite() )
    }
}

class CellStateNotRegisteredAsFavorite: NSObject, AriticleState {
    func favoriteButtonTapped(articleCell: TimetableViewController) {
        articleCell.addFavorite()
        articleCell.setState(state: CellStateRegisteredAsFavorite())
    }
}
