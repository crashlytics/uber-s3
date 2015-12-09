require 'spec_helper'

describe UberS3::Response do

  it 'raises Unknown Error when the xml document is invalid' do
    options = {
      :status => 503,
      :header => "some header",
      :body => "body",
      :raw => ""
    }
    expect{UberS3::Response.new(options)}.to raise_error(UberS3::Error::Unknown, "HTTP Response: 503, Body: body")
  end

end