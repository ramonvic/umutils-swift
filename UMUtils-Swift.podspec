Pod::Spec.new do |spec|

    spec.name         = "UMUtils-Swift"
    spec.version      = "0.2.0"
    spec.summary      = "Utility Class Library"
    spec.homepage     = "https://github.com/ramonvic"
    spec.license      = { :type => "MIT", :file => "LICENSE.md" }
    spec.author       = { "Ramon Vicente" => "ramonvicentesilva@hotmail.com" }
    spec.platform     = :ios, '9.0'
    spec.source       = { 
        :git => "https://github.com/ramonvic/umutils-swift.git", 
        :tag => "0.2.0" }
    spec.requires_arc = true

    spec.default_subspec = 'Core'

    spec.subspec 'Core' do |ss|
        ss.source_files = 'Sources/Core/**/*.swift'
    end

    spec.subspec 'Material' do |ss|
        ss.source_files = 'Sources/Material/**/*.swift'

        ss.dependency 'UMUtils-Swift/Core'
        ss.dependency 'Material', '~> 2.0'
    end

    spec.subspec 'Rx' do |ss|
        ss.source_files = 'Sources/Rx/*.swift'
        
        ss.dependency 'UMUtils-Swift/Core'
        ss.dependency 'RxSwift', '~> 3.1'
        ss.dependency 'RxCocoa', '~> 3.1'
        ss.dependency 'RxOptional', '~> 3.1'
        ss.dependency 'RxSwiftUtilities', '~> 1.0.1'
    end

    spec.subspec 'MBProgressHUD_Rx' do |ss|
        ss.source_files = 'Sources/Rx/MBProgressHUD/**/*.swift'

        ss.dependency 'UMUtils-Swift/Rx'
        ss.dependency 'MBProgressHUD', '~> 1.0'
    end

    spec.subspec 'AIFlatSwitch_Rx' do |ss|
        ss.source_files = 'Sources/Rx/AIFlatSwitch/**/*.swift'

        ss.dependency 'UMUtils-Swift/Rx'
        ss.dependency 'AIFlatSwitch', '~> 1.0'
    end

    spec.subspec 'APIClient' do |ss|
        ss.dependency 'UMUtils-Swift/Core'
    end

    spec.subspec 'Popup' do |ss|
        ss.source_files = 'Sources/Popup/**/*.swift'
        ss.dependency 'CNPPopupController', '~> 0.3.3'
    end

    spec.subspec 'PushNotification' do |ss|
        ss.dependency 'UMUtils-Swift/Core'
    end
end
