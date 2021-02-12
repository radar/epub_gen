require 'spec_helper'

RSpec.describe EpubGen::TOC do
  let(:book) { EpubGen::Book.new(path: File.expand_path("./fixtures/book", __dir__), uuid: "123") }

  it "generates a toc tree" do
    tree = book.toc.tree
    expect(tree.text).to eq("ROOT")
    expect(tree.children.first.text).to eq("Active Rails")
    expect(tree.children.first.children[0].text).to eq("Preface")
    expect(tree.children.first.children[1].text).to eq("Acknowledgements")
    expect(tree.children.first.children[2].text).to eq("About this book")
    expect(tree.children.first.children[3].text).to eq("1. Ruby on Rails, the framework")
    expect(tree.children.first.children[3].children[0].text).to eq("1.1. Ruby on Rails overview")
    expect(tree.children.first.children[3].children[0].children.first.text).to eq("Benefits")
    expect(tree.children.first.children[3].children[0].children.first.children.first.text).to eq("Ruby Gems")
  end
end
