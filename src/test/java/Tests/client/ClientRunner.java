package Tests.client;

import com.intuit.karate.KarateOptions;
import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

//  Running using Terminal
//  mvn clean test -Dkarate.options="--tags @smoke" -Dtest=GarageRunner.java
//  After running from Terminal you can see the report in: target/cucumber-html-reports/overview-failures.html

@KarateOptions(tags = { "@smoke", "@alltests", "~@ignore" }) // important: do not use @RunWith(Karate.class) !
class ClientRunner {

    @Test
    public void testParallel() {
        if (System.getProperty("karate.env") == null) {
            System.setProperty("karate.env", "demo");
        }
        Results results = Runner.parallel(getClass(), 5);
        generateReport(results.getReportDir());
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }

    private static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[] { "json" }, true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("target"), "demo");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }

}
