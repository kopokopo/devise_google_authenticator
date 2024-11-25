$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name = "devise_google_authenticator"
  s.version = "1.0.0"
  s.authors = ["Christian Frichot"]
  s.date = "2015-02-08"
  s.description = "Devise Google Authenticator Extension, for adding Google's OTP to your Rails apps!"
  s.email = "xntrik@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = Dir["{app,config,lib}/**/*"] + %w[LICENSE.txt README.rdoc]
  s.homepage = "http://github.com/AsteriskLabs/devise_google_authenticator"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.summary = "Devise Google Authenticator Extension"

  s.required_rubygems_version = '>= 3.3.5'

  {
    'devise'  => '>= 4.9.4',
    'rotp'    => '~> 6.3',
    'rqrcode' => '~> 2.2',
    'rails' => '~> 7.2',
  }.each do |lib, version|
    s.add_runtime_dependency(lib, *version)
  end
end
