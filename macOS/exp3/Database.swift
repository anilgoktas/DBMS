//
//  Database.swift
//  exp3
//
//  Created by Anıl Göktaş on 4/11/16.
//  Copyright © 2016 Anıl Göktaş. All rights reserved.
//

import Foundation

final class Database {
    
    // MARK: - Singleton
    
    static let sharedDatabase = Database()
    
    // MARK: - Tables
    
    let tableCount = 14
    
    var artist = [Artist]()
    var genre = [Genre]()
    var publisher = [Publisher]()
    var song = [Song]()
    var webUser = [WebUser]()
    var album = [Album]()
    var albumHasSong = [AlbumHasSong]()
    var artistHasAlbum = [ArtistHasAlbum]()
    var artistHasGenre = [ArtistHasGenre]()
    var artistSingsSong = [ArtistSingsSong]()
    var playlist = [Playlist]()
    var songHasGenre = [SongHasGenre]()
    var webUserHasFavoriteArtist = [WebUserHasFavoriteArtist]()
    var webUserHasFavoriteGenre = [WebUserHasFavoriteGenre]()
    
    // MARK: - Life Cycle
    
    private init() {
        
    }
    
    // MARK: - Configurable
    
    func configure() {
        Artist.table { (elements) in
            self.artist = elements
        }
        
        Genre.table { (elements) in
            self.genre = elements
        }
        
        Publisher.table { (elements) in
            self.publisher = elements
        }
        
        Song.table { (elements) in
            self.song = elements
        }
        
        WebUser.table { (elements) in
            self.webUser = elements
        }
        
        Album.table { (elements) in
            self.album = elements
        }
        
        AlbumHasSong.table { (elements) in
            self.albumHasSong = elements
        }
        
        ArtistHasAlbum.table { (elements) in
            self.artistHasAlbum = elements
        }
        
        ArtistHasGenre.table { (elements) in
            self.artistHasGenre = elements
        }
        
        ArtistSingsSong.table { (elements) in
            self.artistSingsSong = elements
        }
        
        Playlist.table { (elements) in
            self.playlist = elements
        }
        
        SongHasGenre.table { (elements) in
            self.songHasGenre = elements
        }
        
        WebUserHasFavoriteArtist.table { (elements) in
            self.webUserHasFavoriteArtist = elements
        }
        
        WebUserHasFavoriteGenre.table { (elements) in
            self.webUserHasFavoriteGenre = elements
        }
    }
    
}

// MARK: - Subscript

extension Database {
    
    func table(index index: Int) -> [AnyObject] {
        switch(index) {
        case 0: return artist
        case 1: return genre
        case 2: return publisher
        case 3: return song
        case 4: return webUser
        case 5: return album
        case 6: return albumHasSong
        case 7: return artistHasAlbum
        case 8: return artistHasGenre
        case 9: return artistSingsSong
        case 10: return playlist
        case 11: return songHasGenre
        case 12: return webUserHasFavoriteArtist
        case 13: return webUserHasFavoriteGenre
        default: return [Int]()
        }
    }
    
    func entity(index index: Int) -> Entity.Type {
        switch(index) {
        case 0: return Artist.self
        case 1: return Genre.self
        case 2: return Publisher.self
        case 3: return Song.self
        case 4: return WebUser.self
        case 5: return Album.self
        case 6: return AlbumHasSong.self
        case 7: return ArtistHasAlbum.self
        case 8: return ArtistHasGenre.self
        case 9: return ArtistSingsSong.self
        case 10: return Playlist.self
        case 11: return SongHasGenre.self
        case 12: return WebUserHasFavoriteArtist.self
        case 13: return WebUserHasFavoriteGenre.self
        default: return Artist.self
        }
    }
    
    subscript(index index: Int) -> [AnyObject] {
        get {
            switch(index) {
            case 0: return artist
            case 1: return genre
            case 2: return publisher
            case 3: return song
            case 4: return webUser
            case 5: return album
            case 6: return albumHasSong
            case 7: return artistHasAlbum
            case 8: return artistHasGenre
            case 9: return artistSingsSong
            case 10: return playlist
            case 11: return songHasGenre
            case 12: return webUserHasFavoriteArtist
            case 13: return webUserHasFavoriteGenre
            default: return [Int]()
            }
        }
        set {
            switch(index) {
            case 0: artist = newValue as? [Artist] ?? [Artist]()
            case 1: genre = newValue as? [Genre] ?? [Genre]()
            case 2: publisher = newValue as? [Publisher] ?? [Publisher]()
            case 3: song = newValue as? [Song] ?? [Song]()
            case 4: webUser = newValue as? [WebUser] ?? [WebUser]()
            case 5: album = newValue as? [Album] ?? [Album]()
            case 6: albumHasSong = newValue as? [AlbumHasSong] ?? [AlbumHasSong]()
            case 7: artistHasAlbum = newValue as? [ArtistHasAlbum] ?? [ArtistHasAlbum]()
            case 8: artistHasGenre = newValue as? [ArtistHasGenre] ?? [ArtistHasGenre]()
            case 9: artistSingsSong = newValue as? [ArtistSingsSong] ?? [ArtistSingsSong]()
            case 10: playlist = newValue as? [Playlist] ?? [Playlist]()
            case 11: songHasGenre = newValue as? [SongHasGenre] ?? [SongHasGenre]()
            case 12: webUserHasFavoriteArtist = newValue as? [WebUserHasFavoriteArtist] ?? [WebUserHasFavoriteArtist]()
            case 13: webUserHasFavoriteGenre = newValue as? [WebUserHasFavoriteGenre] ?? [WebUserHasFavoriteGenre]()
            default: break
            }
        }
    }
    
}