RSpec.describe CreateRsf do
  payload = { "country" => "Foo & Bar" }
  describe 'RSF encoding' do
    it 'preserves literal characters' do
      rsf = CreateRsf.call(payload, 'country')
      expect(rsf).to include('Foo & Bar')
    end
  end
end
