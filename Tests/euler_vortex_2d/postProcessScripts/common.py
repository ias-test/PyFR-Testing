
def getPalette(minV,maxV):
    if(minV>0 and maxV>0):
        c=[
            [    0.0, 0.0, 0.0,      ],
            [    0.0, 0.0, 0.501961, ],
            [    0.0, 0.501961, 1.0, ],
            [    1.0, 1.0, 1.0       ],
            ]
    else:
        c=[
         [0.404089, 0.131044, 0.592767], 
         [0.486473, 0.230961, 0.651240], 
         [0.575158, 0.339330, 0.717723], 
         [0.662745, 0.454337, 0.784268], 
         [0.742077, 0.570214, 0.842924], 
         [0.806928, 0.678996, 0.886229], 
         [0.852216, 0.771313, 0.907637], 
         [0.873350, 0.837324, 0.901579], 
         [1.000000, 1.000000, 1.000000], 
         [0.828397, 0.858228, 0.796811],
         [0.762585, 0.814282, 0.700206],
         [0.676432, 0.744228, 0.585733],
         [0.577035, 0.657313, 0.461524],
         [0.471275, 0.562478, 0.334752],
         [0.365454, 0.467964, 0.210758],
         [0.264759, 0.381140, 0.087830],
         [0.182589, 0.312245, 0.000000]
        ]
    return c
