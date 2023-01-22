package modiCorp.biller;

import com.intuit.karate.junit5.Karate;

class TestRunner {
    
    @Karate.Test
    Karate testUsers() {
        return Karate.run("biller").relativeTo(getClass());
    }    

}
