require_relative 'spec_helper'

EtcPwnam = Struct.new(:name, :gid)

describe 'test::profile' do
  let(:chef_run) do
    pw_user = EtcPwnam.new
    pw_user.name = 'test1'
    pw_user.gid = 'test1'
    Dir.stub(:home).and_return('/home/test1')
    Etc.stub(:getpwnam).and_return(pw_user)
    ChefSpec::Runner.new(step_into: ['bash_profile'])
  end

  context 'init' do
    context 'default' do
      before do
        File.stub(:exists?).and_call_original
        IO.stub(:read).and_call_original
        File.should_receive(:exists?).with('/home/test1/.bash_profile').and_return(true)
        File.should_receive(:exists?).with('/home/test1/.bash_profile.d/init').and_return(false)
        IO.should_receive(:read).with('/home/test1/.bash_profile').and_return('')
        chef_run.converge described_recipe
      end

      it 'to create .bash_profile.d directory' do
        expect(chef_run).to create_directory('/home/test1/.bash_profile.d')
      end

      it 'to create .bash_profile.d/init file' do
        expect(chef_run).to create_file('/home/test1/.bash_profile.d/init')
      end

      it 'to replace .bash_profile with cookbook file' do
        expect(chef_run).to create_cookbook_file('/home/test1/.bash_profile')
      end
    end

    context 'to touch' do
      before do
        chef_run.converge described_recipe
      end

      it '.bash_profile.d/init file' do
        expect(chef_run).to touch_file('/home/test1/.bash_profile.d/init')
      end
    end
  end

  context 'test1' do
    before do
      chef_run.converge described_recipe
    end

    it 'create .bash_profile.d/test1 file' do
      expect(chef_run).to create_file('/home/test1/.bash_profile.d/test1')
    end
  end

  context 'matcher' do
    before do
      chef_run.converge described_recipe
    end

    it 'add_bash_profile' do
      expect(chef_run).to add_bash_profile('test1')
    end
  end
end