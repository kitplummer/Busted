# Copyright: Kit Plummer
# http://creativecommons.org/licenses/by-sa/3.0/us/

require File.dirname(__FILE__) + "/../busted_json"
describe BustedJson, "all" do
    it 'returns valid json' do
        j = JSON.parse(BustedJson.busses(1))
        j['Route']['id'].should == 1
    end
end
