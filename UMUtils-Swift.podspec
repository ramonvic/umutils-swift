Pod::Spec.new do |spec|

    spec.name         = "UMUtils-Swift"
    spec.version      = "0.0.1"
    spec.summary      = "Utility Class Library"
    spec.homepage     = "https://github.com/ramonvic/UMUtils-Swift"
    spec.screenshots  = "https://github.com/ramonvic/UMUtils-Swift/raw/master/Docs/screen1.png"
    spec.license      = { :type => "MIT", :file => "LICENSE.md" }
    spec.author       = { "Ramon Vicente" => "ramonvicentesilva@hotmail.com" }
    spec.platform     = :ios, '8.0'
    spec.source       = { 
        :git => "https://github.com/ramonvic/UMUtils-Swiftpec.git", 
        :tag => "0.1.0" }
    spec.requires_arc = true

    spec.default_subspec = 'Core'

    spec.subspec 'Core' do |ss|
        spec.source_files  = "UMUtils-Swift/Core/**/*.{h,m}"
    end

    spec.subspec 'APIClient' do |ss|
        ss.dependency 'UMUtils-Swift/Core'
    end

    spec.subspec 'PushNotification' do |ss|
        ss.dependency 'UMUtils-Swift/Core'
    end
end
