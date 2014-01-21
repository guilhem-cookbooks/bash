require_relative 'spec_helper'

EtcPwnam = Struct.new(:name, :gid)

describe 'test::profile' do
  let(:chef_run) do
    pw_user = EtcPwnam.new
    pw_user.name = 'test_user'
    pw_user.gid = 'users'
    Dir.stub(:home).and_return('/home/test_user')
    Etc.stub(:getpwnam).and_return(pw_user)
    ChefSpec::Runner.new(step_into: ['bash_profile'])
  end

  context 'action create' do
    context 'init' do
      context 'default' do
        before do
          File.stub(:exists?).and_call_original
          IO.stub(:read).and_call_original
          File.should_receive(:exists?).with('/home/test_user/.bash_profile').and_return(true)
          File.should_receive(:exists?).with('/home/test_user/.bash_profile.d/init').and_return(false)
          IO.should_receive(:read).with('/home/test_user/.bash_profile').and_return('')
          chef_run.converge described_recipe
        end

        it 'to create .bash_profile.d directory' do
          expect(chef_run).to create_directory('/home/test_user/.bash_profile.d')
        end

        it 'to create .bash_profile.d/init file' do
          expect(chef_run).to create_file('/home/test_user/.bash_profile.d/init')
        end

        it 'to replace .bash_profile with cookbook file' do
          expect(chef_run).to create_cookbook_file('/home/test_user/.bash_profile')
        end
      end

      context 'to touch' do
        before do
          chef_run.converge described_recipe
        end

        it '.bash_profile.d/init file' do
          expect(chef_run).to touch_file('/home/test_user/.bash_profile.d/init')
        end
      end
    end

    context 'test1' do
      before do
        chef_run.converge described_recipe
      end

      it 'create .bash_profile.d/test1 file' do
        expect(chef_run).to create_file('/home/test_user/.bash_profile.d/test1')
      end

      it 'append chef warning to .bash_profile.d/test1 file' do
        expect(chef_run).to render_file('/home/test_user/.bash_profile.d/test1')
          .with_content <<-EOH
# Managed by Chef.  Local changes will be overwritten.
test1
EOH
      end
    end
  end

  context 'action remove' do
    before do
      chef_run.converge described_recipe
    end

    it 'delete .bash_profile.d/test2 file' do
      expect(chef_run).to delete_file('/home/test_user/.bash_profile.d/test2')
    end
  end

  context 'matcher' do
    before do
      chef_run.converge described_recipe
    end

    it 'add_bash_profile' do
      expect(chef_run).to add_bash_profile('test1')
    end

    it 'remove_bash_profile' do
      expect(chef_run).to remove_bash_profile('test2')
    end
  end
end