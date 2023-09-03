package clever.bank;

import java.util.Calendar;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AccountBalance {
    protected Double balance;
    protected Calendar amountStartTs;
    protected Calendar amountEndTs;
    protected boolean isCurrent;

}
