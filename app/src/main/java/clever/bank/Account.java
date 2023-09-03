package clever.bank;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Account extends AccountBalance {

    protected String accId; 
    protected String accIdWithinBank; // 10 sym (form 1)
    protected String accOpenDate;
    protected String accCloseDate;

}
