table.on("tableBuilt", () => {
  const lectureUniqueValues = [...new Set(table.getData().map((row) => row.lecture))];
  const semesterUniqueValues = [...new Set(table.getData().map((row) => row.semester))];

  table.getColumn("lecture").updateDefinition({
    headerFilter: "select", // Change to a dropdown filter
    headerFilterParams: {
      values: [
        { value: "", label: "----" }, // Label for the empty string
        ...lectureUniqueValues.map((value) => ({
          value,
          label: value,
        })),
      ],
    //   valuesLookup: true, 
    },
    headerFilterPlaceholder: "Filter by lecture",
  });

  table.getColumn("semester").updateDefinition({
    headerFilter: "select", // Change to a dropdown filter
    headerFilterParams: {
      values: [
        { value: "", label: "----" }, // Label for the empty string
        ...semesterUniqueValues.map((value) => ({
          value,
          label: value,
        })),
      ],
    //   valuesLookup: true, 
    },
    headerFilterPlaceholder: "Filter by semester",
  });
});


console.log("HALLOOOOO")