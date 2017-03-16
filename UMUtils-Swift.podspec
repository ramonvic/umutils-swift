Pod::Spec.new do |spec|

    spec.name         = "UMUtils-Swift"
    spec.version      = "0.0.1"
    spec.summary      = "Utility Class Library"
    spec.homepage     = "https://github.com/ramonvic"
    spec.license      = { :type => "MIT", :file => "LICENSE.md" }
    spec.author       = { "Ramon Vicente" => "ramonvicentesilva@hotmail.com" }
    spec.platform     = :ios, '8.0'
    spec.source       = { :path => '.' }
    spec.requires_arc = true

    spec.default_subspec = 'Core'

    spec.subspec 'Core' do |ss|
        ss.ios.deployment_target = '8.0'
        spec.ios.source_files  = "Sources/Core/**/*.swift"
    end

    spec.subspec 'APIClient' do |ss|
        ss.dependency 'UMUtils-Swift/Core'
    end

    spec.subspec 'PushNotification' do |ss|
        ss.dependency 'UMUtils-Swift/Core'
    end
end
