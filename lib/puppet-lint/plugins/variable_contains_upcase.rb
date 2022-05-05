PuppetLint.new_check(:variable_contains_upcase) do
  def check
    tokens.select do |r|
      Set[:VARIABLE, :UNENC_VARIABLE].include? r.type
    end.each do |token|
      next unless token.value.gsub(/\[.+?\]/, '').match(/[A-Z]/)

      notify :warning, {
        message: 'variable contains a capital letter',
        line: token.line,
        column: token.column,
        token: token
      }
    end
  end

  def fix(problem)
    problem[:token].value.gsub(/::/, '/')
                   .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                   .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                   .tr('-', '_')
                   .downcase
  end
end
