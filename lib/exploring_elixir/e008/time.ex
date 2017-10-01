defmodule ExploringElixir.Time do
  def for_next_week(fun) when is_function(fun, 1) do
    today = Date.utc_today
    next_week = Date.add today, 7
    Date.range(today, next_week) |> Enum.each(fun)
    :ok
  end

  def seconds_per_day, do: 60 * 60 * 24
end

defmodule ExploringElixir.Time.Local do
  def beam_timestamp do
    System.system_time
  end

  def os_timestamp do
    System.os_time
  end

  def monotonic_time do
    System.monotonic_time
  end

  def monotonic_time_offset do
    System.time_offset
  end

  def adjusted_monotonic_time do
    System.monotonic_time + System.time_offset
  end

  def current_time do
    NaiveDateTime.to_time current_date()
  end

  def current_date do
    NaiveDateTime.utc_now
  end

  def yesterday do
    NaiveDateTime.add current_date(), -(ExploringElixir.Time.seconds_per_day()), :seconds
  end

  def just_a_day_away do
    Date.diff current_date(), yesterday()
  end
end

defmodule ExploringElixir.Time.Calendars do
  def today_iso do
    Date.utc_today
  end

  def today_jalaali do
    Date.utc_today Jalaali.Calendar
  end

  def convert_to_jalaali(date) do
    {:ok, date} = Date.convert date, Jalaali.Calendar
    date
  end
end

defmodule ExploringElixir.Time.Stored do
  require ExploringElixir.Repo.Tenants, as: Repo
  import Ecto.Query

  @spec put(date_time :: DateTime.t(), data :: String.t()) :: id :: integer()
  def put(date_time, data) when is_bitstring(data) do
    utc = Timex.to_datetime date_time, "Etc/UTC"
    Repo.insert_all "dates_and_times", [%{
                                          a_date: DateTime.to_date(utc),
                                          a_time: DateTime.to_time(utc),
                                          with_tz: utc,
                                          data: data
                                       }]
  end

  @spec get(date :: DateTime.t()) :: [{id :: integer, data :: String.t()}]
  def get(date_time) do
    date = DateTime.to_date(date_time)
    query = from d in "dates_and_times",
                 where: d.a_date == ^date,
                 select: {d.id, d.data}
    Repo.all query
  end
end
