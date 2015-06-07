require 'recipe_tool/recipes_loader'

describe RecipeTool::RecipesLoader do
  let(:loader) { described_class.new }
  let(:content) { [{ name: 'オムライス' }, { name: '親子丼' }, { name: '杏仁豆腐' }] }

  describe '#call' do
    context 'when recieve valid file path' do
      let(:valid_path) { 'src/recipes.yml' }
      it 'returns file contents' do
        expect(loader.call(valid_path)).to eq content
      end
    end

    context 'when do not reviev file path' do
      it 'returns `src/recipes.yml`file contents' do
        expect(loader.call).to eq content
      end
    end

    context 'when reviev invalid file path' do
      let(:not_exist_file) { 'not_exist_path' }
      let(:invalid_extname) { 'src/invalid.txt' }

      it 'raises Error invalid file path' do
        expect { loader.call(not_exist_path) }.to raise_error
        expect { loader.call(invalid_extname) }.to raise_error
      end
    end
  end
end
