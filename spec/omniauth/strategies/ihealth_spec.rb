require 'spec_helper'
require 'omniauth-ihealth-oauth2'
require 'pry'

describe OmniAuth::Strategies::IHealth do
  let(:request) { double('Request', params: {}, cookies: {}, env: {}) }
  let(:app) do
    lambda do
      [200, {}, ['Hello.']]
    end
  end

  subject do
    OmniAuth::Strategies::IHealth.new(app, 'appid', 'secret', @options || {}).tap do |strategy|
      allow(strategy).to receive(:request) do
        request
      end
    end
  end

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  it 'adds camelization for itself' do
    expect(OmniAuth::Utils.camelize('ihealth')).to eq('iHealth')
  end

  describe '#client' do
    it 'has correct iHealth site' do
      expect(subject.client.site).to eq('https://api.ihealthlabs.com:8443')
    end

    it 'has correct `authorize_url`' do
      expect(subject.client.options[:authorize_url]).to eq('/OpenApiV2/OAuthv2/userauthorization/')
    end

    it 'has correct `token_url`' do
      expect(subject.client.options[:token_url]).to eq('/OpenApiV2/OAuthv2/userauthorization/')
    end
  end

  describe '#callback_path' do
    it 'has the correct callback path' do
      expect(subject.callback_path).to eq('/auth/ihealth/callback')
    end
  end

  describe '#uid' do
    before :each do
      allow(subject).to receive(:access_token) { Hash[user_id: 'uid'] }
    end

    it 'returns the id from raw_info' do
      expect(subject.uid).to eq('uid')
    end
  end

  describe '#access_token' do
    let(:expires_in) { 3600 }
    let(:token) { 'token' }
    let(:access_token) do
      instance_double OAuth2::AccessToken, :expires_in => expires_in, :token => token
    end

    before :each do
      allow(subject).to receive(:access_token).and_return access_token
    end

    specify { expect(subject.access_token.expires_in).to eq expires_in }
  end

  describe '#authorize_params' do
    describe 'scope' do
      it 'sets default scope' do
        expect(subject.authorize_params['scope']).to eq('OpenApiUserInfo')
      end

      it 'sets custom scope' do
        @options = { scope: 'OpenApiActivity OpenApiUserInfo' }
        expect(subject.authorize_params['scope']).to eq('OpenApiActivity OpenApiUserInfo')
      end
    end

    describe 'APIName' do
      it 'sets default APIName' do
        expect(subject.authorize_params['APIName']).to eq('OpenApiUserInfo')
      end

      it 'sets custom APIName' do
        @options = { scope: 'OpenApiActivity OpenApiUserInfo' }
        expect(subject.authorize_params['APIName']).to eq('OpenApiActivity OpenApiUserInfo')
      end
    end
  end
end
