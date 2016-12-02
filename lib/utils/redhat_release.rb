module Utils
  class RedhatRelease
    LEGACY_DISTRO_TEMPLATE = 'centos%{major_version}'.freeze

    VERSION_SEPARATOR = '.'.freeze # this may change to "dot" and "hyphen" if we allow not only final releases(beta, custom git builds, etc)
    VERSION_SEPARATOR_REGEXP = Regexp.escape(VERSION_SEPARATOR).freeze # regexp to match single "dot" character

    VERSION_REGEXP = %r{              # /etc/redhat-release samples: "CentOS Linux release 7.1.1503 (Core)", "Red Hat Enterprise Linux Server release 7.2 (Maipo)"
      (?<=[[:space:]])                # positive lookbehind assertion: ensures that the preceding character matches single "space" character, but doesn't include this character in the matched text
      (?<major_version>[[:digit:]])   # :major_version named capture group; it matches single digits
      #{VERSION_SEPARATOR_REGEXP}     # regexp for separator of version parts
      (?<minor_version>[[:digit:]]+)  # :minor_version named capture group; it matches one or more sequential digits
      (?:                             # grouping without capturing; "monthstamp" version part don't exist for versions of Centos older then 7
        #{VERSION_SEPARATOR_REGEXP}   # regexp for separator of version parts
        (?<monthstamp>[[:digit:]]{4}) # :monthstamp named capture group; it matches 4 sequential digits
      )?                              # zero or one times quantifier(repetition metacharacter)
      (?=[[:space:]])                 # positive lookahead assertion: ensures that the following character matches single "space" character, but doesn't include this character in the matched text
    }x.freeze

    DEFAULT_VERSION_ARR = [6, 0].freeze

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

    def monthstamp
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
        version_match[:major_version],
        version_match[:minor_version],
        version_match[:monthstamp]
      ].compact.map(&:to_i)
    end

    def version_match
      return @version_match if defined?(@version_match)

      @version_match = VERSION_REGEXP.match(release_string)
    end
  end
end
