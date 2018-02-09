module UsefulUtilities
  class CentOSVersion
    attr_reader :version

    def initialize(version)
      @version = version.to_i
    end

    class << self
      def centos5?(*args)
        new(*args).centos5?
      end
      alias_method :five?, :centos5?

      def centos6?(*args)
        new(*args).centos6?
      end
      alias_method :six?, :centos6?

      def centos7?(*args)
        new(*args).centos7?
      end
      alias_method :seven?, :centos7?

      def not_centos5?(*args)
        new(*args).not_centos5?
      end
    end

    def centos5?
      version == 5
    end
    alias_method :five?, :centos5?

    def centos6?
      version == 6
    end
    alias_method :six?, :centos6?

    def centos7?
      version == 7
    end
    alias_method :seven?, :centos7?

    def not_centos5?
      !centos5?
    end
  end
end
