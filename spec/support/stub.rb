module Stub

def stub(url, file_path)
    host = URI.parse(url).host
    stub_request(:get, url)
      .with(headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip, deflate', 'Host' => host })
      .to_return(status: 200, body: File.open(file_path, &:read), headers: {})
  end
end