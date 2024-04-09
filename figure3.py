
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

# Assuming 'dwi' DataFrame exists with 'bac1' and 'recidivism' columns
dwi = pd.read_csv('hansen_dwi.csv')  # Uncomment this line and specify the path to your data

# For demonstration, let's create a sample DataFrame similar to 'dwi'
np.random.seed(0)  # For reproducible results
sample_size = 1000
dwi = pd.DataFrame({
    'bac1': np.random.uniform(0, 0.21, sample_size),
    'recidivism': np.random.uniform(0.07, 0.17, sample_size)
})

# Data transformation as per the provided R code
dwi['dui'] = np.where(dwi['bac1'] > 0.15, 2, 1)
dwi['avg_rec'] = dwi.groupby('bac1')['recidivism'].transform('mean')

# Plotting
fig, axes = plt.subplots(1, 2, figsize=(15, 6))

# Panel A: Linear Fit
sns.regplot(x='bac1', y='avg_rec', data=dwi, ax=axes[0], scatter_kws={'alpha': 0.3}, line_kws={'color': 'red'}, order=1)
axes[0].axvline(x=0.08, color='tomato', linestyle='--')
axes[0].axvline(x=0.15, color='tomato', linestyle='--')
axes[0].set_xlim(0, 0.21)
axes[0].set_ylim(0.07, 0.17)
axes[0].set_title('Panel A. All Offenders (Linear Fit)')
axes[0].set_xlabel('BAC')
axes[0].set_ylabel('Average Recidivism')

# Panel B: Quadratic Fit
sns.regplot(x='bac1', y='avg_rec', data=dwi, ax=axes[1], scatter_kws={'alpha': 0.3}, line_kws={'color': 'blue'}, order=2)
axes[1].axvline(x=0.08, color='tomato', linestyle='--')
axes[1].axvline(x=0.15, color='tomato', linestyle='--')
axes[1].set_xlim(0, 0.21)
axes[1].set_ylim(0.07, 0.17)
axes[1].set_title('Panel A. All Offenders (Quadratic Fit)')
axes[1].set_xlabel('BAC')
axes[1].set_ylabel('')

plt.tight_layout()
plt.show()
