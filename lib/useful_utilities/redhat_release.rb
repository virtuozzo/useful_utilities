module UsefulUtilities
  # Redhat releases utilities
  class RedhatRelease
    LEGACY_DISTRO_TEMPLATE = 'centos%{major_version}'.freeze
    private_constant :LEGACY_DISTRO_TEMPLATE

    VERSION_SEPARATOR = '.'.freeze # this may change to "dot" and "hyphen" if we allow not only final releases(beta, custom git builds, etc)
    VERSION_SEPARATOR_REGEXP = Regexp.escape(VERSION_SEPARATOR).freeze # regexp to match single "dot" character
    private_constant :VERSION_SEPARATOR, :VERSION_SEPARATOR_REGEXP

    VERSION_REGEXP = %r{              # /etc/redhat-release samples: "CentOS Linux release 7.1.1503 (Core)", "Red Hat Enterprise Linux Server release 7.2 (Maipo)"
      (?<=[[:space:]])                # positive lookbehind assertion: ensures that the preceding character matches single "space" character, but doesn't include this character in the matched text
      (?<major>[[:digit:]])           # :major named capture group; it matches single digits
      #{VERSION_SEPARATOR_REGEXP}     # regexp for separator of version parts
      (?<minor>[[:digit:]]+)          # :minor named capture group; it matches one or more sequential digits
      (?:                             # grouping without capturing; patch version does not exist for versions of CentOS older then 7
        #{VERSION_SEPARATOR_REGEXP}   # regexp for separator of version parts
        (?<patch>[[:digit:]]+)        # :patch named capture group; it matches one or more sequential digits
      )?                              # zero or one times quantifier(repetition metacharacter)
      (?=[[:space:]])?                # positive lookahead assertion: ensures that the following character matches single "space" character, but doesn't include this character in the matched text
    }x.freeze
    private_constant :VERSION_REGEXP

    DEFAULT_VERSION_ARR = [6, 0].freeze
    private_constant :DEFAULT_VERSION_ARR

    attr_reader :release_string

    def initialize(release_string)
      @release_string = release_string.to_s
    end

    def self.major_version(*args)
      new(*args).major_version
    end

    def self.legacy_distro(ver)
      LEGACY_DISTRO_TEMPLATE % { major_version: ver }
    end

    def major_version
      version_arr[0]
    end

    def minor_version
      version_arr[1]
    end

    def patch_version
      version_arr[2]
    end

    def version_string
      version_arr.join(VERSION_SEPARATOR)
    end

    private

    def version_arr
      @version_arr ||= version_match.present? ? match_version_arr : DEFAULT_VERSION_ARR
    end

    def match_version_arr
      @match_version_arr ||= [
        version_match[:major],
        version_match[:minor],
        version_match[:patch]
      ].compact.map(&:to_i)
    end

    def version_match
      return @version_match if defined?(@version_match)

      @version_match = VERSION_REGEXP.match(release_string)
    end
  end
end
