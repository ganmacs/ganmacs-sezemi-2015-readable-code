require 'recipe_tool/parser'

describe RecipeTool::Parser do
  let(:parser) { described_class.new(args) }
  let(:path) { 'your/file/path.txt' }

  describe '#args' do
    context 'when do not recieve args' do
      let(:args) { [] }
      it 'exits with code 1' do
        expect { parser.args }.to raise_error SystemExit # exit
      end
    end

    context 'when recieve one arg' do
      let(:args) { [path] }
      it 'returns args which has recipe_path key' do
        expect(parser.args[:recipe_paths]).to eq [path]
      end
    end

    context 'when recieve two args' do
      context 'and second arg is user_name' do
        let(:user) { 'user_name' }
        let(:args) { [user, path] }
        it 'returns ars which has recipe_path and user_names' do
          expect(parser.args[:recipe_paths]).to eq [path]
          expect(parser.args[:user_names]).to eq [user]
        end
      end

      context 'and second arg is recipe_id' do
        let(:recipe_id) { '2' }
        let(:args) { [path, recipe_id] }

        it 'returns ars which has recipe_path and recipe_id' do
          expect(parser.args[:recipe_paths]).to eq [path]
          expect(parser.args[:recipe_id]).to eq recipe_id.to_i
        end
      end
    end

    context 'when recieve three args' do
      let(:recipe_id) { '2' }
      let(:user) { 'user_name' }
      let(:args) { [user, path, recipe_id] }

      it 'returns ars which has recipe_path, recipe_id and user_names' do
        expect(parser.args[:recipe_paths]).to eq [path]
        expect(parser.args[:user_names]).to eq [user]
        expect(parser.args[:recipe_id]).to eq recipe_id.to_i
      end
    end

    context 'when recieve three more args' do
      let(:user) { 'user_name' }
      let(:user2) { 'user_name2' }
      let(:path2) { 'path2.txt' }

      context 'and recieve recipe_id' do
        let(:recipe_id) { '2' }
        let(:args) { [user, path, user2, path2, recipe_id] }

        it 'returns ars which has recipe_path, recipe_id and user_names' do
          expect(parser.args[:recipe_paths]).to eq [path, path2]
          expect(parser.args[:user_names]).to eq [user, user2]
          expect(parser.args[:recipe_id]).to eq recipe_id.to_i
        end
      end

      context 'and not recieve recipe_id' do
        let(:args) { [user, path, user2, path2] }

        it 'returns ars which has recipe_path, recipe_id and user_names' do
          expect(parser.args[:recipe_paths]).to eq [path, path2]
          expect(parser.args[:user_names]).to eq [user, user2]
          expect(parser.args[:recipe_id]).to be_nil
        end
      end
    end
  end
end
