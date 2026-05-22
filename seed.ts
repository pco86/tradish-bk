/**
 * ! Executing this script will delete all data in your database and seed it with 10 buckets_vectors.
 * ! Make sure to adjust the script to your needs.
 * Use any TypeScript runner to run this script, for example: `npx tsx seed.ts`
 * Learn more about the Seed Client by following our guide: https://docs.snaplet.dev/seed/getting-started
 */
import { createSeedClient } from "@snaplet/seed";

const main = async () => {
  const seed = await createSeedClient({ dryRun: true });

  const relationEvents = await seed.events([
    {
      visibility: "system",
      user_id: null,
      title: "Palm Sunday",
      short_description:
        "The commemoration of Jesus' triumphal entry into Jerusalem.",
      long_description:
        "The [beginning of Holy Week](https://libguides.asu.edu), recalled with the blessing of palm branches to signify the crowds who welcomed Jesus.",
    },
    {
      visibility: "system",
      user_id: null,
      title: "Easter",
      short_description:
        "The celebration of the Passion, Death, and Resurrection of Jesus.",
      long_description:
        "The [holiest period of the Church year](https://seaportshrine.org), including the Easter Vigil—the first liturgical celebration of the Resurrection—and Easter Sunday.",
      event_date_rules_event_date_rules_event_idToevents: [{
        rule_type: "computed",
        algorithm: "easter-western",
        calendar_type: "gregorian",
        frequency: "yearly",
        month: null,
        day: null,
        operations: [],
        config: { algorithm: "easter-western" },
        weekday: null,
        week_of_month: null,
        interval: null,
        relative_event_id: null,
      }],
    },
    {
      visibility: "system",
      user_id: null,
      title: "Feast of the Ascension",
      short_description: "Celebrates Jesus Christ ascending into heaven.",
      long_description:
        "Occurring 40 days after the Resurrection, this feast marks the moment [Jesus ascended bodily into heaven](https://www.christianity.com) in the presence of His apostles.",
    },
    {
      visibility: "system",
      user_id: null,
      title: "Pentecost",
      short_description: "The descent of the Holy Spirit upon the Apostles.",
      long_description:
        "Celebrated 50 days after Easter, it commemorates the [Holy Spirit coming to the disciples](https://libguides.asu.edu) as 'tongues of fire,' marking the birth of the Church.",
    },
    {
      visibility: "system",
      user_id: null,
      title: "Christmas",
      short_description:
        "The Nativity of Jesus Christ and the beginning of Christmastide.",
      long_description:
        "A major solemnity celebrating the [birth of Jesus Christ](https://www.vaticannews.va) in Bethlehem. It marks the end of Advent and the start of the Christmas season.",

      event_date_rules_event_date_rules_event_idToevents: [{
        rule_type: "fixed",
        algorithm: null,
        calendar_type: "gregorian",
        frequency: "yearly",
        month: 11,
        day: 25,
        operations: [],
        config: { month: 11, day: 25 },
        weekday: null,
        week_of_month: null,
        interval: null,
        relative_event_id: null,
      }],
    },
    {
      visibility: "system",
      user_id: null,
      title: "Feast of Corpus Christi",
      short_description:
        "The Solemnity of the Most Holy Body and Blood of Christ.",
      long_description:
        "A feast honoring the real presence of the [body and blood of Jesus](https://github.com) in the Eucharist, traditionally celebrated after Trinity Sunday.",
    },
    {
      visibility: "system",
      user_id: null,
      title: "First Sunday of Advent",
      short_description:
        "The beginning of the liturgical year and a season of preparation.",
      long_description:
        "Marks the start of the [Advent season](https://www.usccb.org worship/liturgical-year/advent), a time of expectant waiting and preparation for both the celebration of the Nativity of Christ at Christmas and the return of Christ at the Second Coming.",
    },
    {
      visibility: "system",
      user_id: null,
      title: "Solemnity of Christ the King",
      short_description: "Honors Jesus Christ as Lord of all creation.",
      long_description:
        "The final Sunday of the [liturgical year](https://www.facebook.com), emphasizing Christ's sovereignty over the universe.",
    },
    {
      visibility: "system",
      user_id: null,
      title: "Totensonntag",
      short_description:
        "Sunday of the Dead; a German Protestant day of remembrance.",
      long_description:
        "The last Sunday before Advent in German Lutheran traditions, dedicated to [remembering those who have died](https://www.christianity.com) in the past year.",
    },
    {
      visibility: "system",
      user_id: null,
      title: "Solemnity of Mary, Mother of God",
      short_description: "A celebration of Mary's motherhood of Jesus.",
      long_description:
        "Observed on January 1st, this [Holy Day of Obligation](https://www.xavier.edu) honors the Blessed Virgin Mary as the 'Theotokos' (God-bearer).",
    },
    {
      visibility: "system",
      user_id: null,
      title: "Epiphany of the Lord",
      short_description: "Commemorates the revelation of Christ to the world.",
      long_description:
        "Celebrates the [manifestation of the divine nature of Jesus](https://library.framingham.edu) to the Magi, signifying that the savior has come for all nations.",
    },
    {
      visibility: "system",
      user_id: null,
      title: "Feast of the Transfiguration",
      short_description:
        "Commemorates Jesus' radiant appearance on Mount Tabor.",
      long_description:
        "Recalls the event where [Jesus’ physical appearance became brilliant](https://laverne.edu) as He spoke with Moses and Elijah, revealing His divine glory.",
    },
    {
      visibility: "system",
      user_id: null,
      title: "Feast of the Assumption",
      short_description:
        "Celebrates Mary being taken body and soul into heaven.",
      long_description:
        "A [Catholic solemnity](https://www.xavier.edu) on August 15th observing the Blessed Virgin Mary's assumption into heavenly glory.",
    },
    {
      visibility: "system",
      user_id: null,
      title: "The Exaltation of the Holy Cross",
      short_description:
        "Also known as Holy Rood Day, honoring the Cross of Christ.",
      long_description:
        "Commemorates the finding and [annual elevation of the cross](https://buildfaith.org) used in the crucifixion of Jesus Christ.",
    },
    {
      visibility: "system",
      user_id: null,
      title: "Reformation Day",
      short_description:
        "Commemorates the start of the Protestant Reformation.",
      long_description:
        "Observed on October 31st, marking the anniversary of [Martin Luther nailing the 95 Theses](https://www.faithward.org) to the church door in Wittenberg.",
    },
    {
      visibility: "system",
      user_id: null,
      title: "All Saints' Day",
      short_description: "Honoring all saints, known and unknown.",
      long_description:
        "A day to honor all those who have achieved [lives of holiness](https://libguides.asu.edu) or were martyred for their faith. Also referred to as Solemnity of All Saints.",
    },
    {
      visibility: "system",
      user_id: null,
      title: "Feast of the Immaculate Conception",
      short_description:
        "Celebrates Mary being conceived without original sin.",
      long_description:
        "A [Holy Day of Obligation](https://www.bbcatholic.org.au) on December 8th, celebrating the belief that Mary was preserved from original sin from her conception.",
    },
  ]);

  const palmSunday = relationEvents.events[0];
  const easter = relationEvents.events[1];
  const ascension = relationEvents.events[2];
  const pentecost = relationEvents.events[3];
  const christmas = relationEvents.events[4];
  const corpusChristi = relationEvents.events[5];
  const oneAdvent = relationEvents.events[6];
  const solemnity = relationEvents.events[7];
  const totensonntag = relationEvents.events[8];
  const solemnityMary = relationEvents.events[9];
  const epiphany = relationEvents.events[10];
  const transfiguration = relationEvents.events[11];
  const assumption = relationEvents.events[12];
  const exaltation = relationEvents.events[13];
  const reformation = relationEvents.events[14];
  const saints = relationEvents.events[15];
  const conception = relationEvents.events[16];

  await seed.event_date_rules([
    {
      event_id: palmSunday.id,
      relative_event_id: easter.id,
      rule_type: "relative",
      algorithm: null,
      calendar_type: "gregorian",
      frequency: null,
      operations: ["offset-days:-7"],
      event_date_rule_operations: [{
        sort_order: 0,
        type: "offset-days",
        config: { "amount": -7 },
      }],
      config: null,
      month: null,
      day: null,
      weekday: null,
      week_of_month: null,
      interval: null,
    },
    {
      event_id: ascension.id,
      relative_event_id: easter.id,
      rule_type: "relative",
      algorithm: null,
      calendar_type: "gregorian",
      frequency: null,
      operations: ["offset-days:40"],
      event_date_rule_operations: [{
        sort_order: 0,
        type: "offset-days",
        config: { "amount": 40 },
      }],
      config: null,
      month: null,
      day: null,
      weekday: null,
      week_of_month: null,
      interval: null,
    },
    {
      event_id: pentecost.id,
      relative_event_id: easter.id,
      rule_type: "relative",
      algorithm: null,
      calendar_type: "gregorian",
      frequency: null,
      operations: ["offset-days:50"],
      event_date_rule_operations: [{
        sort_order: 0,
        type: "offset-days",
        config: { "amount": 50 },
      }],
      config: null,
      month: null,
      day: null,
      weekday: null,
      week_of_month: null,
      interval: null,
    },
    {
      event_id: corpusChristi.id,
      relative_event_id: easter.id,
      rule_type: "relative",
      algorithm: null,
      calendar_type: "gregorian",
      frequency: null,
      operations: ["offset-days:60"],
      event_date_rule_operations: [{
        sort_order: 0,
        type: "offset-days",
        config: { "amount": 60 },
      }],
      config: null,
      month: null,
      day: null,
      weekday: null,
      week_of_month: null,
      interval: null,
    },
    {
      event_id: oneAdvent.id,
      relative_event_id: christmas.id,
      rule_type: "relative",
      algorithm: null,
      calendar_type: "gregorian",
      frequency: null,
      operations: ["previous-weekday-strict:0", "offset-weeks:-3"],
      event_date_rule_operations: [{
        sort_order: 0,
        type: "previous-weekday-strict",
        config: { "weekday": 0 },
      }, {
        sort_order: 1,
        type: "offset-weeks",
        config: { "amount": -3 },
      }],
      config: null,
      month: null,
      day: null,
      weekday: null,
      week_of_month: null,
      interval: null,
    },
    {
      event_id: solemnity.id,
      relative_event_id: oneAdvent.id,
      rule_type: "relative",
      algorithm: null,
      calendar_type: "gregorian",
      frequency: null,
      operations: ["offset-weeks:-1"],
      event_date_rule_operations: [{
        sort_order: 0,
        type: "offset-weeks",
        config: { "amount": -1 },
      }],
      config: null,
      month: null,
      day: null,
      weekday: null,
      week_of_month: null,
      interval: null,
    },
    {
      event_id: totensonntag.id,
      relative_event_id: oneAdvent.id,
      rule_type: "relative",
      algorithm: null,
      calendar_type: "gregorian",
      frequency: null,
      operations: ["offset-weeks:-1"],
      event_date_rule_operations: [{
        sort_order: 0,
        type: "offset-weeks",
        config: { "amount": -1 },
      }],
      config: null,
      month: null,
      day: null,
      weekday: null,
      week_of_month: null,
      interval: null,
    },
    {
      event_id: solemnityMary.id,
      rule_type: "fixed",
      algorithm: null,
      calendar_type: "gregorian",
      frequency: "yearly",
      operations: [],
      config: { month: 0, day: 1 },
      month: 0,
      day: 1,
      weekday: null,
      week_of_month: null,
      interval: null,
      relative_event_id: null,
    },
    {
      event_id: epiphany.id,
      rule_type: "fixed",
      algorithm: null,
      calendar_type: "gregorian",
      frequency: "yearly",
      operations: [],
      config: { month: 0, day: 6 },
      month: 0,
      day: 6,
      weekday: null,
      week_of_month: null,
      interval: null,
      relative_event_id: null,
    },
    {
      event_id: transfiguration.id,
      rule_type: "fixed",
      algorithm: null,
      calendar_type: "gregorian",
      frequency: "yearly",
      operations: [],
      config: { month: 7, day: 6 },
      month: 7,
      day: 6,
      weekday: null,
      week_of_month: null,
      interval: null,
      relative_event_id: null,
    },
    {
      event_id: assumption.id,
      rule_type: "fixed",
      algorithm: null,
      calendar_type: "gregorian",
      frequency: "yearly",
      operations: [],
      config: { month: 7, day: 15 },
      month: 7,
      day: 15,
      weekday: null,
      week_of_month: null,
      interval: null,
      relative_event_id: null,
    },
    {
      event_id: exaltation.id,
      rule_type: "fixed",
      algorithm: null,
      calendar_type: "gregorian",
      frequency: "yearly",
      operations: [],
      config: { month: 8, day: 14 },
      month: 8,
      day: 14,
      weekday: null,
      week_of_month: null,
      interval: null,
      relative_event_id: null,
    },
    {
      event_id: reformation.id,
      rule_type: "fixed",
      algorithm: null,
      calendar_type: "gregorian",
      frequency: "yearly",
      operations: [],
      config: { month: 9, day: 31 },
      month: 9,
      day: 31,
      weekday: null,
      week_of_month: null,
      interval: null,
      relative_event_id: null,
    },
    {
      event_id: saints.id,
      rule_type: "fixed",
      algorithm: null,
      calendar_type: "gregorian",
      frequency: "yearly",
      operations: [],
      config: { month: 10, day: 1 },
      month: 10,
      day: 1,
      weekday: null,
      week_of_month: null,
      interval: null,
      relative_event_id: null,
    },
    {
      event_id: conception.id,
      rule_type: "fixed",
      algorithm: null,
      calendar_type: "gregorian",
      frequency: "yearly",
      operations: [],
      config: { month: 10, day: 1 },
      month: 10,
      day: 1,
      weekday: null,
      week_of_month: null,
      interval: null,
      relative_event_id: null,
    },
  ]);

  // Seed the database with 10 buckets_vectors
  await seed.traditions([
    {
      visibility: "system",
      user_id: null,
      event_id: solemnity.id,
      title: "Solemnity Tradish 1",
      short_description:
        "The virvonta or virpominen (meaning the act of refreshment or wishing) is performed by Finnish children on Palm Sunday to wish well to the households.",
      long_description:
        "Virvonta was formed from a mixture of blessing customs that had been maintained by Orthodox Christians in Eastern Finland and a Western Finnish trulli tradition that is akin to the Swedish easter witch practice[3][4][5] with pre-Christian roots.",
      is_default: true,
      operations: ["offset-days:0"],
      tradition_date_rule_operations: [{
        type: "offset-days",
        config: { amount: 0 },
        sort_order: 0,
      }],
      tradition_prep_steps: [{
        description: "Step 1 get ready",
        sort_order: 0,
        step_type: "default",
      }, {
        description: "Step 2 get ready",
        sort_order: 1,
        step_type: "default",
      }, {
        description: "Step 3 get ready",
        sort_order: 2,
        step_type: "default",
      }],
    },
    {
      visibility: "system",
      user_id: null,
      event_id: solemnity.id,
      title: "Solemnity Tradish 2",
      short_description:
        "The virvonta or virpominen (meaning the act of refreshment or wishing) is performed by Finnish children on Palm Sunday to wish well to the households.",
      long_description:
        "Virvonta was formed from a mixture of blessing customs that had been maintained by Orthodox Christians in Eastern Finland and a Western Finnish trulli tradition that is akin to the Swedish easter witch practice[3][4][5] with pre-Christian roots.",
      is_default: false,
      operations: ["offset-days:-1"],
      tradition_date_rule_operations: [{
        type: "offset-days",
        config: { amount: -1 },
        sort_order: 0,
      }],
      tradition_prep_steps: [{
        description: "Step 1 get ready",
        sort_order: 0,
        step_type: "default",
      }, {
        description: "Step 2 get ready",
        sort_order: 1,
        step_type: "default",
      }, {
        description: "Step 3 get ready",
        sort_order: 2,
        step_type: "default",
      }],
    },
    {
      visibility: "system",
      user_id: null,
      event_id: oneAdvent.id,
      title: "Advent Tradish 1",
      short_description:
        "The virvonta or virpominen (meaning the act of refreshment or wishing) is performed by Finnish children on Palm Sunday to wish well to the households.",
      long_description:
        "Virvonta was formed from a mixture of blessing customs that had been maintained by Orthodox Christians in Eastern Finland and a Western Finnish trulli tradition that is akin to the Swedish easter witch practice[3][4][5] with pre-Christian roots.",
      is_default: true,
      operations: ["offset-days:0"],
      tradition_date_rule_operations: [{
        type: "offset-days",
        config: { amount: 0 },
        sort_order: 0,
      }],
      tradition_prep_steps: [{
        description: "Step 1 get ready",
        sort_order: 0,
        step_type: "default",
      }, {
        description: "Step 2 get ready",
        sort_order: 1,
        step_type: "default",
      }, {
        description: "Step 3 get ready",
        sort_order: 2,
        step_type: "default",
      }],
    },
    {
      visibility: "system",
      user_id: null,
      event_id: oneAdvent.id,
      title: "Advent Tradish 2",
      short_description:
        "The virvonta or virpominen (meaning the act of refreshment or wishing) is performed by Finnish children on Palm Sunday to wish well to the households.",
      long_description:
        "Virvonta was formed from a mixture of blessing customs that had been maintained by Orthodox Christians in Eastern Finland and a Western Finnish trulli tradition that is akin to the Swedish easter witch practice[3][4][5] with pre-Christian roots.",
      is_default: false,
      operations: ["offset-days:-1"],
      tradition_date_rule_operations: [{
        type: "offset-days",
        config: { amount: -1 },
        sort_order: 0,
      }],
      tradition_prep_steps: [{
        description: "Step 1 get ready",
        sort_order: 0,
        step_type: "default",
      }, {
        description: "Step 2 get ready",
        sort_order: 1,
        step_type: "default",
      }, {
        description: "Step 3 get ready",
        sort_order: 2,
        step_type: "default",
      }],
    },
    {
      visibility: "system",
      user_id: null,
      event_id: corpusChristi.id,
      title: "Corpus Christi Tradish 1",
      short_description:
        "The virvonta or virpominen (meaning the act of refreshment or wishing) is performed by Finnish children on Palm Sunday to wish well to the households.",
      long_description:
        "Virvonta was formed from a mixture of blessing customs that had been maintained by Orthodox Christians in Eastern Finland and a Western Finnish trulli tradition that is akin to the Swedish easter witch practice[3][4][5] with pre-Christian roots.",
      is_default: true,
      operations: ["offset-days:0"],
      tradition_date_rule_operations: [{
        type: "offset-days",
        config: { amount: 0 },
        sort_order: 0,
      }],
      tradition_prep_steps: [{
        description: "Step 1 get ready",
        sort_order: 0,
        step_type: "default",
      }, {
        description: "Step 2 get ready",
        sort_order: 1,
        step_type: "default",
      }, {
        description: "Step 3 get ready",
        sort_order: 2,
        step_type: "default",
      }],
    },
    {
      visibility: "system",
      user_id: null,
      event_id: corpusChristi.id,
      title: "Corpus Christi Tradish 2",
      short_description:
        "The virvonta or virpominen (meaning the act of refreshment or wishing) is performed by Finnish children on Palm Sunday to wish well to the households.",
      long_description:
        "Virvonta was formed from a mixture of blessing customs that had been maintained by Orthodox Christians in Eastern Finland and a Western Finnish trulli tradition that is akin to the Swedish easter witch practice[3][4][5] with pre-Christian roots.",
      is_default: false,
      operations: ["offset-days:-1"],
      tradition_date_rule_operations: [{
        type: "offset-days",
        config: { amount: -1 },
        sort_order: 0,
      }],
      tradition_prep_steps: [{
        description: "Step 1 get ready",
        sort_order: 0,
        step_type: "default",
      }, {
        description: "Step 2 get ready",
        sort_order: 1,
        step_type: "default",
      }, {
        description: "Step 3 get ready",
        sort_order: 2,
        step_type: "default",
      }],
    },
    {
      visibility: "system",
      user_id: null,
      event_id: christmas.id,
      title: "Christmas Tradish 1",
      short_description:
        "The virvonta or virpominen (meaning the act of refreshment or wishing) is performed by Finnish children on Palm Sunday to wish well to the households.",
      long_description:
        "Virvonta was formed from a mixture of blessing customs that had been maintained by Orthodox Christians in Eastern Finland and a Western Finnish trulli tradition that is akin to the Swedish easter witch practice[3][4][5] with pre-Christian roots.",
      is_default: true,
      operations: ["offset-days:0"],
      tradition_date_rule_operations: [{
        type: "offset-days",
        config: { amount: 0 },
        sort_order: 0,
      }],
      tradition_prep_steps: [{
        description: "Step 1 get ready",
        sort_order: 0,
        step_type: "default",
      }, {
        description: "Step 2 get ready",
        sort_order: 1,
        step_type: "default",
      }, {
        description: "Step 3 get ready",
        sort_order: 2,
        step_type: "default",
      }],
    },
    {
      visibility: "system",
      user_id: null,
      event_id: christmas.id,
      title: "Christmas Tradish 2",
      short_description:
        "The virvonta or virpominen (meaning the act of refreshment or wishing) is performed by Finnish children on Palm Sunday to wish well to the households.",
      long_description:
        "Virvonta was formed from a mixture of blessing customs that had been maintained by Orthodox Christians in Eastern Finland and a Western Finnish trulli tradition that is akin to the Swedish easter witch practice[3][4][5] with pre-Christian roots.",
      is_default: false,
      operations: ["offset-days:-1"],
      tradition_date_rule_operations: [{
        type: "offset-days",
        config: { amount: -1 },
        sort_order: 0,
      }],
      tradition_prep_steps: [{
        description: "Step 1 get ready",
        sort_order: 0,
        step_type: "default",
      }, {
        description: "Step 2 get ready",
        sort_order: 1,
        step_type: "default",
      }, {
        description: "Step 3 get ready",
        sort_order: 2,
        step_type: "default",
      }],
    },
    {
      visibility: "system",
      user_id: null,
      event_id: pentecost.id,
      title: "Pentecost Tradish 1",
      short_description:
        "The virvonta or virpominen (meaning the act of refreshment or wishing) is performed by Finnish children on Palm Sunday to wish well to the households.",
      long_description:
        "Virvonta was formed from a mixture of blessing customs that had been maintained by Orthodox Christians in Eastern Finland and a Western Finnish trulli tradition that is akin to the Swedish easter witch practice[3][4][5] with pre-Christian roots.",
      is_default: true,
      operations: ["offset-days:0"],
      tradition_date_rule_operations: [{
        type: "offset-days",
        config: { amount: 0 },
        sort_order: 0,
      }],
      tradition_prep_steps: [{
        description: "Step 1 get ready",
        sort_order: 0,
        step_type: "default",
      }, {
        description: "Step 2 get ready",
        sort_order: 1,
        step_type: "default",
      }, {
        description: "Step 3 get ready",
        sort_order: 2,
        step_type: "default",
      }],
    },
    {
      visibility: "system",
      user_id: null,
      event_id: pentecost.id,
      title: "Pentecost Tradish 2",
      short_description:
        "The virvonta or virpominen (meaning the act of refreshment or wishing) is performed by Finnish children on Palm Sunday to wish well to the households.",
      long_description:
        "Virvonta was formed from a mixture of blessing customs that had been maintained by Orthodox Christians in Eastern Finland and a Western Finnish trulli tradition that is akin to the Swedish easter witch practice[3][4][5] with pre-Christian roots.",
      is_default: false,
      operations: ["offset-days:-1"],
      tradition_date_rule_operations: [{
        type: "offset-days",
        config: { amount: -1 },
        sort_order: 0,
      }],
      tradition_prep_steps: [{
        description: "Step 1 get ready",
        sort_order: 0,
        step_type: "default",
      }, {
        description: "Step 2 get ready",
        sort_order: 1,
        step_type: "default",
      }, {
        description: "Step 3 get ready",
        sort_order: 2,
        step_type: "default",
      }],
    },
    {
      visibility: "system",
      user_id: null,
      event_id: ascension.id,
      title: "Ascension Tradish 1",
      short_description:
        "The virvonta or virpominen (meaning the act of refreshment or wishing) is performed by Finnish children on Palm Sunday to wish well to the households.",
      long_description:
        "Virvonta was formed from a mixture of blessing customs that had been maintained by Orthodox Christians in Eastern Finland and a Western Finnish trulli tradition that is akin to the Swedish easter witch practice[3][4][5] with pre-Christian roots.",
      is_default: true,
      operations: ["offset-days:0"],
      tradition_date_rule_operations: [{
        type: "offset-days",
        config: { amount: 0 },
        sort_order: 0,
      }],
      tradition_prep_steps: [{
        description: "Step 1 get ready",
        sort_order: 0,
        step_type: "default",
      }, {
        description: "Step 2 get ready",
        sort_order: 1,
        step_type: "default",
      }, {
        description: "Step 3 get ready",
        sort_order: 2,
        step_type: "default",
      }],
    },
    {
      visibility: "system",
      user_id: null,
      event_id: ascension.id,
      title: "Ascension Tradish 2",
      short_description:
        "The virvonta or virpominen (meaning the act of refreshment or wishing) is performed by Finnish children on Palm Sunday to wish well to the households.",
      long_description:
        "Virvonta was formed from a mixture of blessing customs that had been maintained by Orthodox Christians in Eastern Finland and a Western Finnish trulli tradition that is akin to the Swedish easter witch practice[3][4][5] with pre-Christian roots.",
      is_default: false,
      operations: ["offset-days:-1"],
      tradition_date_rule_operations: [{
        type: "offset-days",
        config: { amount: -1 },
        sort_order: 0,
      }],
      tradition_prep_steps: [{
        description: "Step 1 get ready",
        sort_order: 0,
        step_type: "default",
      }, {
        description: "Step 2 get ready",
        sort_order: 1,
        step_type: "default",
      }, {
        description: "Step 3 get ready",
        sort_order: 2,
        step_type: "default",
      }],
    },
    {
      visibility: "system",
      user_id: null,
      event_id: palmSunday.id,
      title: "Palm Sunday Tradish 1",
      short_description:
        "The virvonta or virpominen (meaning the act of refreshment or wishing) is performed by Finnish children on Palm Sunday to wish well to the households.",
      long_description:
        "Virvonta was formed from a mixture of blessing customs that had been maintained by Orthodox Christians in Eastern Finland and a Western Finnish trulli tradition that is akin to the Swedish easter witch practice[3][4][5] with pre-Christian roots.",
      is_default: true,
      operations: ["offset-days:0"],
      tradition_date_rule_operations: [{
        type: "offset-days",
        config: { amount: 0 },
        sort_order: 0,
      }],
      tradition_prep_steps: [{
        description: "Step 1 get ready",
        sort_order: 0,
        step_type: "default",
      }, {
        description: "Step 2 get ready",
        sort_order: 1,
        step_type: "default",
      }, {
        description: "Step 3 get ready",
        sort_order: 2,
        step_type: "default",
      }],
    },
    {
      visibility: "system",
      user_id: null,
      event_id: palmSunday.id,
      title: "Palm Sunday Tradish 2",
      short_description:
        "The virvonta or virpominen (meaning the act of refreshment or wishing) is performed by Finnish children on Palm Sunday to wish well to the households.",
      long_description:
        "Virvonta was formed from a mixture of blessing customs that had been maintained by Orthodox Christians in Eastern Finland and a Western Finnish trulli tradition that is akin to the Swedish easter witch practice[3][4][5] with pre-Christian roots.",
      is_default: false,
      operations: ["offset-days:-1"],
      tradition_date_rule_operations: [{
        type: "offset-days",
        config: { amount: -1 },
        sort_order: 0,
      }],
      tradition_prep_steps: [{
        description: "Step 1 get ready",
        sort_order: 0,
        step_type: "default",
      }, {
        description: "Step 2 get ready",
        sort_order: 1,
        step_type: "default",
      }, {
        description: "Step 3 get ready",
        sort_order: 2,
        step_type: "default",
      }],
    },
    {
      visibility: "system",
      user_id: null,
      event_id: easter.id,
      title: "Easter Tradish 1",
      short_description:
        "The virvonta or virpominen (meaning the act of refreshment or wishing) is performed by Finnish children on Palm Sunday to wish well to the households.",
      long_description:
        "Virvonta was formed from a mixture of blessing customs that had been maintained by Orthodox Christians in Eastern Finland and a Western Finnish trulli tradition that is akin to the Swedish easter witch practice[3][4][5] with pre-Christian roots.",
      is_default: true,
      operations: ["offset-days:0"],
      tradition_date_rule_operations: [{
        type: "offset-days",
        config: { amount: 0 },
        sort_order: 0,
      }],
      tradition_prep_steps: [{
        description: "Step 1 get ready",
        sort_order: 0,
        step_type: "default",
      }, {
        description: "Step 2 get ready",
        sort_order: 1,
        step_type: "default",
      }, {
        description: "Step 3 get ready",
        sort_order: 2,
        step_type: "default",
      }],
    },
    {
      visibility: "system",
      user_id: null,
      event_id: easter.id,
      title: "Easter Tradish 2",
      short_description:
        "The virvonta or virpominen (meaning the act of refreshment or wishing) is performed by Finnish children on Palm Sunday to wish well to the households.",
      long_description:
        "Virvonta was formed from a mixture of blessing customs that had been maintained by Orthodox Christians in Eastern Finland and a Western Finnish trulli tradition that is akin to the Swedish easter witch practice[3][4][5] with pre-Christian roots.",
      is_default: false,
      operations: ["offset-days:-1"],
      tradition_date_rule_operations: [{
        type: "offset-days",
        config: { amount: -1 },
        sort_order: 0,
      }],
      tradition_prep_steps: [{
        description: "Step 1 get ready",
        sort_order: 0,
        step_type: "default",
      }, {
        description: "Step 2 get ready",
        sort_order: 1,
        step_type: "default",
      }, {
        description: "Step 3 get ready",
        sort_order: 2,
        step_type: "default",
      }],
    },
  ]);

  await seed.rule_type_requirements([
    {
      rule_type: "computed",
      required_fields: ["algorithm"],
    },
    { rule_type: "fixed", required_fields: ["month", "day"] },
    { rule_type: "relative", required_fields: null },
    { rule_type: "weekly", required_fields: ["weekday"] },
  ]);

  process.exit();
};

main();
