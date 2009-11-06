require 'pp'
require 'csv'

class OFX2Google
  @@required_fields = [ "Transaction Description", "Investment Name", "Trade Date", "Transaction Shares", "Share Price", ] 
  def parse_ofx_file(path)
    columns = {}
    output_lines = []
    count = 0
    CSV.open(path, 'r') do |line|
      if count.zero?
        line.each_with_index do |e, index|
          columns[e.strip!] = index
        end
        output_lines << @@required_fields
      else
        output_lines <<
          @@required_fields.map do |f|
            translate(line[columns[f]])
          end
      end
      count += 1
    end
    output_lines
  end
   
  def output_file(path, lines)
    File.open(path, 'w') do |file|
      puts "Writing output that you can upload to Google (#{path})"
      lines.each do |l|
        puts "#{l.join(',')}"
        file.puts l.join(',')
      end
    end
  end

  def translate(str)
    case str
    when 'Plan Contribution' then 'Buy'
    when 'Daily Accrual Dividends' then 'Buy'
    when 'Amazon.com Co. Stock Fund' then 'AMZN'
    when 'Am Beacon SmCap Val Plan' then 'AVPAX'
    when 'Artio Inter Equity Fund A' then 'BJBIX'
    when '500 Index Fund Inv' then 'VFINX'
    when 'Strategic Equity Fund' then 'VSEQX'
    when 'PIMCO Total Return Inst' then 'PTTRX'
    when 'Windsor II Fund Inv' then 'VWNFX'
    when 'Target Retirement 2050' then 'VFIFX'
    else
      str
    end
    
  end
  
  def run
    output_lines = parse_ofx_file('/Users/arnab/Downloads/ofxdownload.csv')
    output_file('/Users/arnab/Downloads/forGoogle.csv', output_lines)
  end
end

OFX2Google.new.run


