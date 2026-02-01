/**
 * ! Executing this script will delete all data in your database and seed it with 10 buckets_vectors.
 * ! Make sure to adjust the script to your needs.
 * Use any TypeScript runner to run this script, for example: `npx tsx seed.ts`
 * Learn more about the Seed Client by following our guide: https://docs.snaplet.dev/seed/getting-started
 */
import { createSeedClient } from "@snaplet/seed";

const main = async () => {
  const seed = await createSeedClient({ dryRun: true });

  // Truncate all tables in the database
  // await seed.$resetDatabase();

  // Seed the database with 10 buckets_vectors
  await seed.traditions([
    {
      title: "Solemnity of Mary, Mother of God",
      short_description: "A celebration of Mary's motherhood of Jesus.",
      long_description:
        "Observed on January 1st, this [Holy Day of Obligation](https://www.xavier.edu) honors the Blessed Virgin Mary as the 'Theotokos' (God-bearer).",
      tradition_date_rules_tradition_date_rules_tradition_idTotraditions: [{
        rule_type: "fixed",
        calendar_type: "gregorian",
        operations: [],
        month: 0,
        day: 1,
        weekday: null,
        week_of_month: null,
        interval: null,
        relative_tradition_id: null,
      }],
    },
    {
      title: "Epiphany of the Lord",
      short_description: "Commemorates the revelation of Christ to the world.",
      long_description:
        "Celebrates the [manifestation of the divine nature of Jesus](https://library.framingham.edu) to the Magi, signifying that the savior has come for all nations.",
      tradition_date_rules_tradition_date_rules_tradition_idTotraditions: [{
        rule_type: "fixed",
        calendar_type: "gregorian",
        operations: [],
        month: 0,
        day: 6,
        weekday: null,
        week_of_month: null,
        interval: null,
        relative_tradition_id: null,
      }],
    },
    {
      title: "Feast of the Transfiguration",
      short_description:
        "Commemorates Jesus' radiant appearance on Mount Tabor.",
      long_description:
        "Recalls the event where [Jesus’ physical appearance became brilliant](https://laverne.edu) as He spoke with Moses and Elijah, revealing His divine glory.",
      tradition_date_rules_tradition_date_rules_tradition_idTotraditions: [{
        rule_type: "fixed",
        calendar_type: "gregorian",
        operations: [],
        month: 7,
        day: 6,
        weekday: null,
        week_of_month: null,
        interval: null,
        relative_tradition_id: null,
      }],
    },
    {
      title: "Feast of the Assumption",
      short_description:
        "Celebrates Mary being taken body and soul into heaven.",
      long_description:
        "A [Catholic solemnity](https://www.xavier.edu) on August 15th observing the Blessed Virgin Mary's assumption into heavenly glory.",
      tradition_date_rules_tradition_date_rules_tradition_idTotraditions: [{
        rule_type: "fixed",
        calendar_type: "gregorian",
        operations: [],
        month: 7,
        day: 15,
        weekday: null,
        week_of_month: null,
        interval: null,
        relative_tradition_id: null,
      }],
    },
    {
      title: "The Exaltation of the Holy Cross",
      short_description:
        "Also known as Holy Rood Day, honoring the Cross of Christ.",
      long_description:
        "Commemorates the finding and [annual elevation of the cross](https://buildfaith.org) used in the crucifixion of Jesus Christ.",
      tradition_date_rules_tradition_date_rules_tradition_idTotraditions: [{
        rule_type: "fixed",
        calendar_type: "gregorian",
        operations: [],
        month: 8,
        day: 14,
        weekday: null,
        week_of_month: null,
        interval: null,
        relative_tradition_id: null,
      }],
    },
    {
      title: "Reformation Day",
      short_description:
        "Commemorates the start of the Protestant Reformation.",
      long_description:
        "Observed on October 31st, marking the anniversary of [Martin Luther nailing the 95 Theses](https://www.faithward.org) to the church door in Wittenberg.",
      tradition_date_rules_tradition_date_rules_tradition_idTotraditions: [{
        rule_type: "fixed",
        calendar_type: "gregorian",
        operations: [],
        month: 9,
        day: 31,
        weekday: null,
        week_of_month: null,
        interval: null,
        relative_tradition_id: null,
      }],
    },
    {
      title: "All Saints' Day",
      short_description: "Honoring all saints, known and unknown.",
      long_description:
        "A day to honor all those who have achieved [lives of holiness](https://libguides.asu.edu) or were martyred for their faith. Also referred to as Solemnity of All Saints.",
      tradition_date_rules_tradition_date_rules_tradition_idTotraditions: [{
        rule_type: "fixed",
        calendar_type: "gregorian",
        operations: [],
        month: 10,
        day: 1,
        weekday: null,
        week_of_month: null,
        interval: null,
        relative_tradition_id: null,
      }],
    },
    {
      title: "Feast of the Immaculate Conception",
      short_description:
        "Celebrates Mary being conceived without original sin.",
      long_description:
        "A [Holy Day of Obligation](https://www.bbcatholic.org.au) on December 8th, celebrating the belief that Mary was preserved from original sin from her conception.",
      tradition_date_rules_tradition_date_rules_tradition_idTotraditions: [{
        rule_type: "fixed",
        calendar_type: "gregorian",
        operations: [],
        month: 10,
        day: 1,
        weekday: null,
        week_of_month: null,
        interval: null,
        relative_tradition_id: null,
      }],
    },
  ]);

  const relationTraditions = await seed.traditions([
    {
      title: "Palm Sunday",
      short_description:
        "The commemoration of Jesus' triumphal entry into Jerusalem.",
      long_description:
        "The [beginning of Holy Week](https://libguides.asu.edu), recalled with the blessing of palm branches to signify the crowds who welcomed Jesus.",
    },
    {
      title: "Easter",
      short_description:
        "The celebration of the Passion, Death, and Resurrection of Jesus.",
      long_description:
        "The [holiest period of the Church year](https://seaportshrine.org), including the Easter Vigil—the first liturgical celebration of the Resurrection—and Easter Sunday.",
      tradition_date_rules_tradition_date_rules_tradition_idTotraditions: [{
        rule_type: "easter",
        calendar_type: "gregorian",
        month: null,
        day: null,
        operations: [],
        weekday: null,
        week_of_month: null,
        interval: null,
        relative_tradition_id: null,
      }],
    },
    {
      title: "Feast of the Ascension",
      short_description: "Celebrates Jesus Christ ascending into heaven.",
      long_description:
        "Occurring 40 days after the Resurrection, this feast marks the moment [Jesus ascended bodily into heaven](https://www.christianity.com) in the presence of His apostles.",
    },
    {
      title: "Pentecost",
      short_description: "The descent of the Holy Spirit upon the Apostles.",
      long_description:
        "Celebrated 50 days after Easter, it commemorates the [Holy Spirit coming to the disciples](https://libguides.asu.edu) as 'tongues of fire,' marking the birth of the Church.",
    },
    {
      title: "Christmas",
      short_description:
        "The Nativity of Jesus Christ and the beginning of Christmastide.",
      long_description:
        "A major solemnity celebrating the [birth of Jesus Christ](https://www.vaticannews.va) in Bethlehem. It marks the end of Advent and the start of the Christmas season.",
      tradition_date_rules_tradition_date_rules_tradition_idTotraditions: [{
        rule_type: "fixed",
        calendar_type: "gregorian",
        month: 11,
        day: 25,
        operations: [],
        weekday: null,
        week_of_month: null,
        interval: null,
        relative_tradition_id: null,
      }],
    },
    {
      title: "Feast of Corpus Christi",
      short_description:
        "The Solemnity of the Most Holy Body and Blood of Christ.",
      long_description:
        "A feast honoring the real presence of the [body and blood of Jesus](https://github.com) in the Eucharist, traditionally celebrated after Trinity Sunday.",
    },
    {
      title: "First Sunday of Advent",
      short_description:
        "The beginning of the liturgical year and a season of preparation.",
      long_description:
        "Marks the start of the [Advent season](https://www.usccb.org worship/liturgical-year/advent), a time of expectant waiting and preparation for both the celebration of the Nativity of Christ at Christmas and the return of Christ at the Second Coming.",
    },
    {
      title: "Solemnity of Christ the King",
      short_description: "Honors Jesus Christ as Lord of all creation.",
      long_description:
        "The final Sunday of the [liturgical year](https://www.facebook.com), emphasizing Christ's sovereignty over the universe.",
    },
    {
      title: "Totensonntag",
      short_description:
        "Sunday of the Dead; a German Protestant day of remembrance.",
      long_description:
        "The last Sunday before Advent in German Lutheran traditions, dedicated to [remembering those who have died](https://www.christianity.com) in the past year.",
    },
  ]);

  const palmSunday = relationTraditions.traditions[0];
  const easter = relationTraditions.traditions[1];
  const ascension = relationTraditions.traditions[2];
  const pentecost = relationTraditions.traditions[3];
  const christmas = relationTraditions.traditions[4];
  const corpusChristi = relationTraditions.traditions[5];
  const oneAdvent = relationTraditions.traditions[6];
  const solemnity = relationTraditions.traditions[7];
  const totensonntag = relationTraditions.traditions[8];

  await seed.tradition_date_rules([
    {
      tradition_id: palmSunday.id,
      relative_tradition_id: easter.id,
      rule_type: "relative",
      calendar_type: "gregorian",
      operations: ["offset-days:-7"],
      month: null,
      day: null,
      weekday: null,
      week_of_month: null,
      interval: null,
    },
    {
      tradition_id: ascension.id,
      relative_tradition_id: easter.id,
      rule_type: "relative",
      calendar_type: "gregorian",
      month: null,
      day: null,
      operations: ["offset-days:40"],
      weekday: null,
      week_of_month: null,
      interval: null,
    },
    {
      tradition_id: pentecost.id,
      relative_tradition_id: easter.id,
      rule_type: "relative",
      calendar_type: "gregorian",
      month: null,
      day: null,
      operations: ["offset-days:50"],
      weekday: null,
      week_of_month: null,
      interval: null,
    },
    {
      tradition_id: corpusChristi.id,
      relative_tradition_id: easter.id,
      rule_type: "relative",
      calendar_type: "gregorian",
      month: null,
      day: null,
      operations: ["offset-days:60"],
      weekday: null,
      week_of_month: null,
      interval: null,
    },
    {
      tradition_id: oneAdvent.id,
      relative_tradition_id: christmas.id,
      rule_type: "relative",
      calendar_type: "gregorian",
      operations: ["strict-previous-weekday:0", "offset-weeks:-3"],
      month: 10,
      day: -7,
      weekday: null,
      week_of_month: null,
      interval: null,
    },
    {
      tradition_id: solemnity.id,
      relative_tradition_id: oneAdvent.id,
      rule_type: "relative",
      calendar_type: "gregorian",
      operations: ["offset-weeks:-1"],
      month: 10,
      day: -7,
      weekday: null,
      week_of_month: null,
      interval: null,
    },
    {
      tradition_id: totensonntag.id,
      relative_tradition_id: oneAdvent.id,
      rule_type: "relative",
      calendar_type: "gregorian",
      operations: ["offset-weeks:-1"],
      month: 10,
      day: -7,
      weekday: null,
      week_of_month: null,
      interval: null,
    },
  ]);

  // Type completion not working? You might want to reload your TypeScript Server to pick up the changes

  // console.log("Database seeded successfully!");

  process.exit();
};

main();
