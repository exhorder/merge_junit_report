describe Fastlane::Actions::MergeJunitReportAction do
  default_output = 'result.xml'

  before(:each) do
    Fastlane::Actions::MergeJunitReportAction.ui = double("FastlaneCore::UI")
    File.delete(default_output) if File.exists?(default_output)
  end
  
  describe '#run' do
    it 'should abort if input files not given' do
      expect(Fastlane::Actions::MergeJunitReportAction.ui).to receive(:error).with('No input files!')

      Fastlane::FastFile.new.parse("lane :merge do
        merge_junit_report(:input_files => [])  
      end").runner.execute(:merge)
    end

    it 'should abort if input file does not exist' do
      expect(Fastlane::Actions::MergeJunitReportAction.ui).to receive(:error).with('File not found: file1.xml')

      Fastlane::FastFile.new.parse("lane :merge do
        merge_junit_report(:input_files => ['file1.xml', 'file2.xml'])  
      end").runner.execute(:merge)
    end

    it 'should merge input files into default result', :focus => true do
      output_file = File.absolute_path(default_output)
      expect(Fastlane::Actions::MergeJunitReportAction.ui).to receive(:success).with("Reports merged to #{output_file} successfully")

      Fastlane::FastFile.new.parse("lane :merge do
        merge_junit_report(:input_files => ['spec/fixtures/report0.xml', 'spec/fixtures/report1.xml'])  
      end").runner.execute(:merge)

      expect(File.exists?(default_output)).to be true
    end
    
  end
end
