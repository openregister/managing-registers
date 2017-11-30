RSpec.describe CreateRsf do
  payload = { "country" => "Foo & Bar" }
  describe 'RSF encoding' do
    it 'preserves literal characters' do
      rsf = CreateRsf.call(payload, 'country')
      expect(rsf).to include('Foo & Bar')
    end
    it 'correctly computes hash' do
      rsf = CreateRsf.call(payload, 'country')
      expect(rsf).to include(Digest::SHA256.hexdigest('{"country":"Foo & Bar"}'))
    end
  end
end
