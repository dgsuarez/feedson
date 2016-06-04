require 'spec_helper'

describe Feedson do
  it "converts an xml to json" do
    json_content = Feedson.parse(
      feed_contents: File.open("spec/examples/itunes.xml"),
      format: :itunes)
    expect(json_content.keys).to eql(["rss"])
  end

  it "converts json to xml" do
    xml = Feedson.dump(json_data: {"rss": {}})
    expect(xml).to match("<rss")

  end
end
