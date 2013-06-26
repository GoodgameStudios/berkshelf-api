require 'spec_helper'

describe Berkshelf::API::CacheBuilder::Worker::ChefServer do
  describe "ClassMethods" do
    subject { described_class }
    its(:worker_type) { should eql("chef_server") }
  end

  subject do
    described_class.new(url: "http://localhost:8889", client_name: "reset",
      client_key: fixtures_path.join("reset.pem"), eager_build: false)
  end

  describe "#cookbooks" do
    before do
      chef_cookbook("ruby", "1.0.0")
      chef_cookbook("ruby", "2.0.0")
      chef_cookbook("elixir", "3.0.0")
      chef_cookbook("elixir", "3.0.1")
    end

    it "returns an array containing an item for each cookbook on the server" do
      expect(subject.cookbooks).to have(4).items
    end

    it "returns an array of RemoteCookbooks" do
      subject.cookbooks.each do |cookbook|
        expect(cookbook).to be_a(Berkshelf::API::RemoteCookbook)
      end
    end
  end
end