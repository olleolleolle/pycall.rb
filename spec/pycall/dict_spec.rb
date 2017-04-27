require 'spec_helper'
require 'pycall/import'

module PyCall
  ::RSpec.describe Dict do
    let(:key) { 'a' }
    let(:mod) { Module.new }
    subject { Dict.new(key => 1, 'b' => 2, 'c' => 3) }

    describe '.new' do
      let(:key) { mod.time.localtime.() }

      before do
        mod.extend PyCall::Import
        mod.pyimport 'time'
      end

      it 'accepts python object as a key' do
        expect{ Dict.new(key => 1) }.not_to raise_error
      end
    end

    describe '#[]' do
      it 'returns a value corresponding to a given key' do
        expect(subject['a']).to eq(1)
        expect(subject['b']).to eq(2)
        expect(subject['c']).to eq(3)
        expect { subject['nothing'] }.not_to raise_error
      end

      it 'increments the returned python object' do
        pyobj = PyCall.eval('object()')
        subject['o'] = pyobj
        expect { subject['o'] }.to change { pyobj.__pyobj__[:ob_refcnt] }.from(2).to(3)
      end

      context 'key is a python object' do
        let(:key) { mod.time.localtime.() }
        before do
          mod.extend PyCall::Import
          mod.pyimport 'time'
        end
        it 'returns a value corresponding to a given key' do
          expect(subject[key]).to eq(1)
        end
      end
    end

    describe '#[]=' do
      it 'stores a given value for a given key' do
        subject['a'] *= 10
        expect(subject['a']).to eq(10)

        subject['b'] *= 10
        expect(subject['b']).to eq(20)

        subject['c'] *= 10
        expect(subject['c']).to eq(30)
      end
    end

    describe '#has_key?' do
      specify do
        expect(subject).to have_key('a')
        expect(subject).to have_key('b')
        expect(subject).to have_key('c')
        expect(subject).not_to have_key('d')
      end
    end
  end
end
