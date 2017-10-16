var drawStats = function(){

  var client = new Keen({
    projectId: "59df7269c9e77c0001156187",
    readKey: "CA832C23E2586CC48FEF3154CF38693DEA5FD24630C80BA3DB804FA257355B63D270E1193FEB54D0365C0686E4761D09AA0C90C2290A213E03FBCBCB9E4AA8AD76424E6054D7D15A1052C45B2B7C25B79F21E27D4A728BC05029F2CC9453DACF"
  });

  var totalUnlocks = new Keen.Dataviz()
    .el("#total-unlocks")
    .height(220)
    .title("Total desbloqueos")
    .colors(['#91C73F'])
    .type("metric")
    .prepare();

  client
    .query("count", {
      event_collection: "unlocks",
      timeframe: "this_30_days",
      timezone: "Europe/Paris"
    })
    .then(function(res) {
      totalUnlocks.data(res).render();
    })
    .catch(function(err) {
      totalUnlocks.message(err.message);
    });

  var unlocksDay = new Keen.Dataviz()
    .el("#unlocks-day")
    .height(240)
    .title("Por baliza y día")
    .type("linechart")
    .prepare();

  client
    .query("count", {
      event_collection: "unlocks",
      group_by: ["lock"],
      interval: "daily",
      timeframe: "this_30_days",
      timezone: "Europe/Paris"
    })
    .then(function(res) {
      unlocksDay.data(res).render();
    })
    .catch(function(err) {
      unlocksDay.message(err.message);
    });

  var unlocksByCentre = function(centre){
    var chart = new Keen.Dataviz()
      .el("#unlocks-centre-" + centre)
      .height(240)
      .title("Por baliza y centro " + centre)
      .type("linechart")
      .prepare();

    client
      .query("count", {
        event_collection: "unlocks",
        filters: [{"operator":"eq","property_name":"centre","property_value": centre}],
        group_by: ["lock"],
        interval: "daily",
        timeframe: "this_30_days",
        timezone: "Europe/Paris"
      })
      .then(function(res) {
        chart.data(res).render();
      })
      .catch(function(err) {
        chart.message(err.message);
      });
  }

  unlocksByCentre('01')
  unlocksByCentre('02')
  unlocksByCentre('03')
  unlocksByCentre('04')
  unlocksByCentre('05')

  var fullyUnlocked = new Keen.Dataviz()
    .el("#fully-unlocked-day")
    .height(240)
    .title("Puzzles desbloqueados")
    .type("areachart")
    .stacked(true)
    .prepare();

  client
    .query("count", {
      event_collection: "full_unlocks",
      interval: "daily",
      timeframe: "this_30_days",
      timezone: "Europe/Paris"
    })
    .then(function(res) {
      fullyUnlocked.data(res).render();
    })
    .catch(function(err) {
      fullyUnlocked.message(err.message);
    });

  var totalFullyUnlocked = new Keen.Dataviz()
    .el("#fully-unlocked-total")
    .height(220)
    .title("Total puzzles desbloqueados")
    .colors(['#91C73F'])
    .type("metric")
    .prepare();

  client
    .query("count", {
      event_collection: "full_unlocks",
      timeframe: "this_30_days",
      timezone: "Europe/Paris"
    })
    .then(function(res) {
      totalFullyUnlocked.data(res).render();
    })
    .catch(function(err) {
      totalFullyUnlocked.message(err.message);
    });

  var completesDay = new Keen.Dataviz()
    .el("#completes-day")
    .height(240)
    .title("Puzzles completados")
    .type("linechart")
    .stacked(true)
    .prepare();

  client
    .query("count", {
      event_collection: "completes",
      group_by: ["image"],
      interval: "daily",
      timeframe: "this_30_days",
      timezone: "Europe/Paris"
    })
    .then(function(res) {
      completesDay.data(res).render();
    })
    .catch(function(err) {
      completesDay.message(err.message);
    });

  var totalCompletes = new Keen.Dataviz()
    .el("#completes-total")
    .height(220)
    .title("Puzzles completados")
    .colors(['#91C73F'])
    .type("metric")
    .prepare();

  client
    .query("count", {
      event_collection: "completes",
      timeframe: "this_30_days",
      timezone: "Europe/Paris"
    })
    .then(function(res) {
      totalCompletes.data(res).render();
    })
    .catch(function(err) {
      totalCompletes.message(err.message);
    });

  var usersCentre = new Keen.Dataviz()
    .el("#unique-users-centre")
    .height(240)
    .title("Usuarios únicos por centro")
    .type("linechart")
    .prepare();

  client
    .query("count_unique", {
      event_collection: "unlocks",
      group_by: ["centre"],
      interval: "daily",
      target_property: "user",
      timeframe: "this_30_days",
      timezone: "Europe/Paris"
    })
    .then(function(res) {
      usersCentre.data(res).render();
    })
    .catch(function(err) {
      usersCentre.message(err.message);
    });

  var uniqueUsers = new Keen.Dataviz()
    .el("#unique-users")
    .height(220)
    .title("Usuarios únicos")
    .colors(['#91C73F'])
    .type("metric")
    .prepare();

  client
    .query("count_unique", {
      event_collection: "unlocks",
      target_property: "user",
      timeframe: "this_30_days",
      timezone: "Europe/Paris"
    })
    .then(function(res) {
      uniqueUsers.data(res).render();
    })
    .catch(function(err) {
      uniqueUsers.message(err.message);
    });
}
