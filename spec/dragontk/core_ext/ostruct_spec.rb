require 'spec_helper'
require 'dragontk/core_ext/ostruct'

class ObjectWithEachPair
  def each_pair
    return to_enum :each_pair unless block_given?
    yield :d, 4
    yield :e, 5
    yield :f, 6
  end
end

describe OpenStruct do
  context '.conj' do
    it 'joins multiple objects together to create an OpenStruct' do
      ostruct = OpenStruct.conj({ a: 1 }, OpenStruct.new(b: 2, c: 3), ObjectWithEachPair.new)
      expect(ostruct.a).to eq(1)
      expect(ostruct.b).to eq(2)
      expect(ostruct.c).to eq(3)
      expect(ostruct.d).to eq(4)
      expect(ostruct.e).to eq(5)
      expect(ostruct.f).to eq(6)
    end
  end
end
