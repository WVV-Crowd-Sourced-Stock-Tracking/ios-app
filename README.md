<h2> WhatsLeft?
  <img src="./img/WhatsleftLogo.svg" align="right" width="128" height="128" />
  <img src="./img/wirvsviruslogo.png" align="right" width="264" height="128" />
</h2>

![wirVsVirus](https://img.shields.io/badge/hackathon-%23WirVsVirus-yellowgreen.svg?style=flat)
![Swift5.1](https://img.shields.io/badge/swift-5.1-blue.svg?style=flat)
![SwiftUI](https://img.shields.io/badge/ui-swiftui-blue.svg?style=flat)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![iOS](https://img.shields.io/badge/os-iOS-green.svg?style=flat)
[![Build Status](https://travis-ci.com/WVV-Crowd-Sourced-Stock-Tracking/ios-app.svg?branch=master)](https://travis-ci.com/WVV-Crowd-Sourced-Stock-Tracking/ios-app)

**WhatsLeft is a crowd-sourced solution to see which items grocery stores have left in stock.**

Die iOS-App verwendet SwiftUI und Combine und wurde in weniger als 48 Stunden als Teil von [#WirvsVirusHack](https://wirvsvirushackathon.org) geschrieben, einem Hackathon, der von der deutschen Regierung organisiert wurde, um eine Lösung für die Probleme in der Coronakrise zu finden.

Ein Like auf unser Youtube-Video würde uns sehr helfen:
[![Youtube-Video](./img/video.png)](https://www.youtube.com/watch?v=2uvcPGzixnA&feature=emb_title)

## Weitere Dokumentationen: 

- [Allgemeine Infos](https://devpost.com/software/17_stock_tracking_crowd)
- [Web App](https://github.com/WVV-Crowd-Sourced-Stock-Tracking/Web) 
- [Android App](https://github.com/WVV-Crowd-Sourced-Stock-Tracking/Android-App)
- [REST-API / Backend](https://github.com/WVV-Crowd-Sourced-Stock-Tracking/Backend)
- [REST-API / Python-Backend](https://github.com/WVV-Crowd-Sourced-Stock-Tracking/Backend-python)

## Code Struktur der iOS / macOS app

Unsere App ist nach MVVM aufgebaut. Dabei findet die Anbindung zum View Model über @ObserverdObjects statt. Dies ermöglicht uns nicht nur eine saubere Trennung von Objekt-Stukturen, Logik und View-Code sondern Live Updates der UI sobald neue Daten vorliegen. 

![MVVM](./img/MVVM.png)

### Struktur der Views

Die Views sind in zwei verschiedene Typen aufgeteilt, MainViews und SubViews. 
SubViews, auch Components genannt, stellen hierbei Views da, die ausschließlich in einer anderen View verwendet werden. Also bei einer Liste ist die Liste die MainView und die Listenelemente sind die SubViews.

### Struktur der ViewModels

Die ViewModels spiegeln die HauptViews wieder. Jede HauptView hat ein eigenes ViewModel, ausgenommen von dieser Regel sind die Detail-, Filter- und Einkaufsliste-View.

### Kommunitkation mit den Backend

Die Kommunikation mit den Backend findet über eine REST-API statt, diese wird durch das Framework Combine ermöglicht. Combine erlaubt es uns, asynchron die Daten zu laden und anschliend durch ein ViewModel die View zu aktualisieren. 

### MacOS app

Bei der MacOS-App handelt es sich um eine Catalyst-App. Catalyst ist ein Framework, welches es uns ermöglicht eine iOS-App als native App unter MacOS laufen zu lassen. 
