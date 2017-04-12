//
//  AppPermissions.swift
//  Meme Me
//
//  Created by Mina Atef on 4/12/17.
//  Copyright © 2017 minaatefmaf. All rights reserved.
//

import Photos

class AppPermissions {
    
    // MARK: Photo Library Permission
    public class func askUserPermissionForThePhotoLibrary() {
        PHPhotoLibrary.requestAuthorization() {_ in }
    }
    
    // MARK: Camera Permission
    public class func askUserPermissionForCamera() {
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) {_ in }
    }
}
