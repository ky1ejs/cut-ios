//
//  FilmDetailVC.swift
//  Cut
//
//  Created by Kyle McAlpine on 18/05/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import EasyPeasy
import AVKit

class FilmDetailVC: UIViewController {
    let detailView: FilmDetailView
    let film: Film
    
    init(film: Film) {
        self.film = film
        self.detailView = FilmDetailView(film: film)
        
        super.init(nibName: nil, bundle: nil)
        
        title = film.title
        
        _ = detailView.trailerButton.rx.tap.takeUntil(rx.deallocated).subscribe(onNext: { _ in
            guard let url = film.trailers?.first?.url else { return }
            let player = AVPlayer(url: url)
            let controller = AVPlayerViewController()
            controller.player = player
            self.present(controller, animated: true, completion: {
                player.play()
            })
        })
        
        _ = detailView.watchView.rateButton.rx.tap.takeUntil(rx.deallocated).subscribe({ _ in
            self.present(RatingPopUpVC(film: self.film), animated: true, completion: nil)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailView
    }
}
