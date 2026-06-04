# Carries all data a single life event needs.
# Every handler gets one of these — nothing more.
LifeEvent = Struct.new(:type, :description, :duration, :timestamp) do
  def to_s
    "[#{timestamp.strftime('%Y-%m-%d %H:%M')}] #{type} — #{description} (#{duration} min)"
  end
end
