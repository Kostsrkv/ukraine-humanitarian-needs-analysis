# Humanitarian Needs and Planned Response Coverage across Ukrainian Oblasts

## An exploratory analysis of HNRP 2026 data

## Executive summary

This brief examines the regional distribution of estimated humanitarian need, planned reach, and severity across 24 Ukrainian oblasts using data from the 2026 Humanitarian Needs and Response Plan.

The analysis shows a strong concentration of humanitarian need in eastern, southern, and frontline-affected oblasts. Kharkivska oblast records the highest aggregated estimate of people in need, followed by Dnipropetrovska, Zaporizka, Sumska, and Donetska oblasts.

Planned reach is generally higher in oblasts classified at the maximum severity level. However, the ratio between planned reach and estimated need varies substantially across regions. These differences should be treated as signals for further monitoring and validation rather than direct evidence of response performance.

This is an exploratory portfolio analysis. Planned reach represents a planning target, not assistance actually delivered.

## Research question

Which Ukrainian oblasts show the highest estimated humanitarian needs, and how does planned reach compare with the scale and severity of those needs?

## Data and methodology

The analysis uses the Ukraine HNRP 2026 JIAF workbook and focuses on selected oblast-level indicators from the following sheets:

- Overall by Strategic Priority and Unit of Analysis;
- Internally Displaced Persons;
- War-Affected Non-Displaced Population.

The analytical workflow was developed in R and included:

1. importing selected sheets from the original Excel workbook;
2. reviewing missing values and inconsistent variable types;
3. retaining valid ADM1-level records;
4. standardising oblast names and administrative codes;
5. converting humanitarian indicators to numeric values;
6. aggregating records to oblast level;
7. calculating a planning coverage ratio:

**planned response coverage = planned reach / estimated people in need**

The analysis also uses the maximum recorded severity level within each oblast as a simplified indicator of the intensity of humanitarian need.

## Key findings

### 1. Humanitarian need is highly concentrated geographically

Kharkivska oblast has the highest aggregated estimate of humanitarian need at approximately 1.25 million. It is followed by:

- Dnipropetrovska: approximately 707,000;
- Zaporizka: approximately 640,000;
- Sumska: approximately 546,000;
- Donetska: approximately 303,000;
- Mykolaivska: approximately 298,000.

Together, the eight oblasts classified at severity level 5 account for approximately three quarters of the aggregated humanitarian need captured in the dataset.

This indicates that the scale and intensity of need remain concentrated primarily in eastern, southern, and frontline-affected regions.

![Estimated people in need by oblast](../outputs/charts/top_people_in_need.png)

### 2. Planned reach broadly reflects humanitarian severity

The eight severity-level-5 oblasts show an average planned coverage ratio of approximately 77%, compared with approximately 35% among severity-level-3 oblasts.

This pattern suggests that the planning framework prioritises oblasts experiencing the most severe humanitarian conditions.

However, planned reach should not be interpreted as assistance already delivered. It reflects planning decisions, prioritisation criteria, available resources, operational capacity, and other programme considerations.

![People in need and planned reach](../outputs/charts/people_in_need_vs_planned_reach.png)

### 3. Planned coverage varies substantially between oblasts

Among the high-need oblasts, the calculated planning coverage ratio ranges from approximately:

- 62% in Zaporizka;
- 72% in Dnipropetrovska;
- 78% in Mykolaivska;
- 80% in Kharkivska and Sumska;
- 84% in Donetska;
- 87% in Khersonska.

Several lower-severity oblasts show considerably lower ratios. These include Cherkaska, Ivano-Frankivska, Rivnenska, Zakarpatska, Ternopilska, and Kyiv city.

These differences should not automatically be interpreted as response gaps or underperformance. They should instead be used to identify cases requiring additional investigation into targeting criteria, population-group definitions, operational access, and programme scope.

![Planned response coverage by oblast](../outputs/charts/response_coverage_by_oblast.png)

### 4. Scale and severity provide different information

The number of people in need measures the estimated scale of humanitarian need, while severity reflects its intensity.

An oblast may have a comparatively smaller affected population but still face highly severe conditions. Conversely, a large oblast may record a high number of people in need without receiving the maximum severity classification.

For prioritisation and monitoring, these indicators should therefore be considered together rather than in isolation.

![Humanitarian needs and planned response coverage](../outputs/charts/needs_vs_response_coverage.png)

## Monitoring implications

The analysis can support monitoring and programme discussions in several ways:

- identify high-need and high-severity oblasts requiring close monitoring;
- flag unusually low or high planning coverage ratios for data-quality review;
- compare planned targeting with subsequent implementation data;
- support regional prioritisation discussions;
- guide further analysis of displacement status, operational access, and population groups.

For operational monitoring, the planning data should be complemented with actual assistance-delivery records, field-monitoring findings, beneficiary feedback, access constraints, and programme-specific indicators.

## Data-quality considerations

The workflow included checks for missing values, inconsistent data types, administrative codes, and non-oblast aggregate rows.

Several limitations remain:

- the current exploratory indicators are aggregated across strategic-priority columns and may include overlap between population groups or needs;
- the resulting figures should not be interpreted as definitive counts of unique individuals;
- planned reach is a planning target rather than evidence of completed assistance;
- maximum severity simplifies variation within an oblast into one value;
- oblast-level aggregation may conceal significant differences between communities;
- The analysis does not yet include time trends or actual implementation data.

## Conclusion

The HNRP 2026 data indicate a clear concentration of humanitarian need in Ukraine’s eastern, southern, and frontline-affected oblasts. Planning targets generally place greater emphasis on the highest-severity regions, although the relationship between estimated need and planned reach varies substantially across oblasts.

The results are best used as an exploratory monitoring and prioritisation tool. They can help identify patterns and questions for further investigation, but they should not replace official operational assessments or programme-level monitoring systems.

## Next steps

The next stage of the project will:

1. validate the aggregation methodology against the workbook documentation;
2. distinguish unique population estimates from potentially overlapping strategic-priority indicators;
3. integrate displacement indicators;
4. incorporate conflict-exposure or access-related data;
5. compare planning targets with actual response-delivery data where available;
6. develop an interactive regional dashboard.
