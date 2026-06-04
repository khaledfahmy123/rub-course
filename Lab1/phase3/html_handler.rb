require_relative 'handler'

# Single job: regenerate the full HTML dashboard on every event.
class HtmlHandler < Handler
  OUTPUT_FILE = 'lifetrack_dashboard.html'

  COLORS = {
    'WORK'    => '#f59e0b',
    'STUDY'   => '#6366f1',
    'EXERCISE'=> '#10b981',
    'MEAL'    => '#f43f5e'
  }

  def initialize
    @events = []
  end

  def handle(event)
    @events << event
    File.write(OUTPUT_FILE, render)
  end

  private

  def render
    rows = @events.map do |e|
      color = COLORS[e.type] || '#94a3b8'
      badge = "<span style='background:#{color};color:#0a0a0a;padding:2px 10px;border-radius:20px;font-size:0.75rem;font-weight:700;letter-spacing:0.08em'>#{e.type}</span>"
      "<tr>
        <td>#{e.timestamp.strftime('%Y-%m-%d %H:%M')}</td>
        <td>#{badge}</td>
        <td>#{e.description}</td>
        <td style='text-align:center'>#{e.duration}</td>
      </tr>"
    end.reverse.join("\n")

    totals = @events.group_by(&:type).map do |type, evs|
      mins = evs.sum(&:duration)
      color = COLORS[type] || '#94a3b8'
      "<div class='stat'>
        <div class='stat-label' style='color:#{color}'>#{type}</div>
        <div class='stat-value'>#{mins} min</div>
        <div class='stat-count'>#{evs.size} session#{evs.size == 1 ? '' : 's'}</div>
      </div>"
    end.join("\n")

    <<~HTML
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <title>LifeTrack Dashboard</title>
        <link href="https://fonts.googleapis.com/css2?family=DM+Mono:wght@400;500&family=Syne:wght@700;800&display=swap" rel="stylesheet">
        <style>
          *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

          :root {
            --bg: #080810;
            --surface: #0f0f1a;
            --border: #1e1e30;
            --text: #e2e2f0;
            --muted: #5a5a7a;
            --accent: #6366f1;
          }

          body {
            background: var(--bg);
            color: var(--text);
            font-family: 'DM Mono', monospace;
            min-height: 100vh;
            padding: 3rem 2rem;
          }

          header {
            margin-bottom: 3rem;
          }

          header h1 {
            font-family: 'Syne', sans-serif;
            font-size: 3rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            background: linear-gradient(135deg, #6366f1 0%, #f59e0b 50%, #10b981 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
          }

          header p {
            color: var(--muted);
            font-size: 0.8rem;
            margin-top: 0.4rem;
            letter-spacing: 0.05em;
          }

          .stats {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            margin-bottom: 2.5rem;
          }

          .stat {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 1.2rem 1.8rem;
            min-width: 140px;
          }

          .stat-label {
            font-family: 'Syne', sans-serif;
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            margin-bottom: 0.4rem;
          }

          .stat-value {
            font-size: 1.6rem;
            font-weight: 500;
            color: var(--text);
          }

          .stat-count {
            font-size: 0.7rem;
            color: var(--muted);
            margin-top: 0.2rem;
          }

          .table-wrap {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 14px;
            overflow: hidden;
          }

          table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.82rem;
          }

          thead tr {
            background: var(--border);
          }

          th {
            padding: 0.9rem 1.2rem;
            text-align: left;
            font-size: 0.65rem;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            color: var(--muted);
            font-weight: 500;
          }

          td {
            padding: 0.85rem 1.2rem;
            color: var(--text);
            border-top: 1px solid var(--border);
            vertical-align: middle;
          }

          tr:hover td { background: rgba(99,102,241,0.05); }

          .empty {
            text-align: center;
            color: var(--muted);
            padding: 3rem;
            font-size: 0.8rem;
          }
        </style>
      </head>
      <body>
        <header>
          <h1>LifeTrack</h1>
          <p>Last updated #{Time.now.strftime('%Y-%m-%d %H:%M:%S')} · #{@events.size} event#{@events.size == 1 ? '' : 's'} total</p>
        </header>

        <div class="stats">
          #{totals.empty? ? '<p style="color:var(--muted);font-size:0.8rem">No events yet.</p>' : totals}
        </div>

        <div class="table-wrap">
          <table>
            <thead>
              <tr>
                <th>Time</th>
                <th>Type</th>
                <th>Description</th>
                <th style="text-align:center">Min</th>
              </tr>
            </thead>
            <tbody>
              #{rows.empty? ? '<tr><td colspan="4" class="empty">No events logged yet.</td></tr>' : rows}
            </tbody>
          </table>
        </div>
      </body>
      </html>
    HTML
  end
end
