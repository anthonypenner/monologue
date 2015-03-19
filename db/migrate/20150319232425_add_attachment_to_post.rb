class AddAttachmentToPost < ActiveRecord::Migration
  class AddAvatarColumnsToUsers < ActiveRecord::Migration
    def self.up
      add_attachment :posts, :landscape
    end

    def self.down
      remove_attachment :posts, :landscape
    end
  end
end
